class MeasureValidator < TradeTariffBackend::Validator
  validation :ME1, 'The combination of measure type + geographical area + goods nomenclature item id + additional code type + additional code + order number + reduction indicator + start date must be unique.', on: [:create, :update], if: -> (record) { record.not_update_of_the_same_measure? } do
    validates :uniqueness, of: [:measure_type_id, :geographical_area_sid, :goods_nomenclature_sid, :additional_code_type_id, :additional_code_id, :ordernumber, :reduction_indicator, :validity_start_date]
  end

  validation :ME2, 'The measure type must exist.', on: [:create, :update] do
    validates :presence, of: :measure_type
  end

  validation :ME3, 'The validity period of the measure type must span the validity period of the measure.', on: [:create, :update] do
    validates :validity_date_span, of: :measure_type, extend_message: true
  end

  validation :ME4, 'The geographical area must exist.', on: [:create, :update] do
    validates :presence, of: :geographical_area
  end

  validation :ME5, 'The validity period of the geographical area must span the validity period of the measure.', on: [:create, :update] do
    validates :validity_date_span, of: :geographical_area, extend_message: true
  end

  validation :ME6, 'The goods code must exist.',
      on: [:create, :update],
      if: ->(record) {
        # NOTE wont apply to national invalidates Measures
        # Taric may delete a Goods Code and national measures will be invalid.
        # ME9 If no additional code is specified then the goods code is mandatory (do not validate if additional code is there)
        # do not validate for export refund nomenclatures
        # do not validate for if related to meursing additional code type
        # do not validate for invalidated national measures (when goods code is deleted by Taric, and CHIEF measures are left orphaned-invalidated)
        (
         (record.additional_code.blank?) &&
         (record.export_refund_nomenclature.blank?) &&
         (!record.national? || !record.invalidated?)
        ) &&
        (record.additional_code_type.present? &&
         !record.additional_code_type.meursing?)
      } do
    validates :presence, of: :goods_nomenclature
  end

  validation :ME7, 'The goods nomenclature code must be a product code; that is, it may not be an intermediate line.', on: [:create, :update] do |record|
    # NOTE wont apply to national invalidates Measures
    # Taric may delete a Goods Code and national measures will be invalid.
    (record.national? && record.invalidated?) ||
    (record.goods_nomenclature.blank?) ||
    (record.goods_nomenclature.present? && record.goods_nomenclature.producline_suffix == "80") || (
    record.export_refund_nomenclature.present? && record.export_refund_nomenclature.productline_suffix == "80"
    )
  end

  validation :ME8, 'The validity period of the goods code must span the validity period of the measure.',
      on: [:create, :update] do
    validates :validity_date_span, of: :goods_nomenclature, extend_message: true
  end

  validation :ME9, 'If no additional code is specified then the goods code is mandatory.', on: [:create, :update] do |record|
    (record.additional_code_id.present?) || (record.additional_code_id.blank? && record.goods_nomenclature_item_id.present?)
  end

  validation :ME10, 'The order number must be specified if the "order number flag" (specified in the measure type record) has the value "mandatory". If the flag is set to "not permitted" then the field cannot be entered.', on: [:create, :update] do |record|
    record.measure_type.present? &&
    ((record.ordernumber.present? && record.measure_type.order_number_capture_code == 1) ||
    (record.ordernumber.blank? && record.measure_type.order_number_capture_code != 1))
  end

  validation :ME12, 'If the additional code is specified then the additional code type must have a relationship with the measure type.',
    on: [:create, :update],
    extend_message: ->(record) { record.measure_sid.present? ? "{ measure_sid=>\"#{record.measure_sid}\" }" : nil } do |record|
    (record.additional_code_type.present? && AdditionalCodeTypeMeasureType.where(additional_code_type_id: record.additional_code_type_id,
                                                                                 measure_type_id: record.measure_type_id).any?) ||
     record.additional_code_type.blank?
  end

  validation :ME13, 'If the additional code type is related to a Meursing table plan then only the additional code can be specified: no goods code, order number or reduction indicator.', on: [:create, :update] do |record|
    (record.additional_code_type.present? &&
     record.additional_code_type.meursing? &&
     record.meursing_additional_code.present? &&
     record.goods_nomenclature_item_id.blank? &&
     record.ordernumber.blank? &&
     record.reduction_indicator.blank?) ||
     (record.additional_code_type.present? && !record.additional_code_type.meursing?) ||
     record.additional_code_type.blank?
  end

  validation :ME14, 'If the additional code type is related to a Meursing table plan then the additional code must exist as a Meursing additional code.', on: [:create, :update] do |record|
     (record.additional_code_type.present? &&
      record.additional_code_type.meursing? &&
      record.meursing_additional_code.present?
     ) || (
      record.additional_code_type.present? && !record.additional_code_type.meursing?
     ) || (
       record.additional_code_type.blank?
     )
  end

  validation :ME16,
    %(Integrating a measure with an additional code when an equivalent or overlapping
    measures without additional code already exists and vice-versa, should be forbidden.),
    on: [:create, :update] do |record|
      valid = true

      attrs = {
        goods_nomenclature_item_id: record.goods_nomenclature_item_id,
        goods_nomenclature_sid: record.goods_nomenclature_sid,
        measure_type_id: record.measure_type_id,
        geographical_area_sid: record.geographical_area_sid,
        ordernumber: record.ordernumber,
        reduction_indicator: record.reduction_indicator,
        additional_code_type_id: record.additional_code_type_id,
        additional_code_id: record.additional_code_id
      }

      if record.modified?
        scope = Measure.where(attrs)
        scope = scope.where("measure_sid != ?", record.measure_sid) if record.measure_sid.present?

        if record.updating_measure.present?
          scope = scope.where("measure_sid != ?", record.updating_measure.measure_sid)
        end

        scope = if record.validity_end_date.present?
                  scope.where(
                    "(validity_start_date <= ? AND (validity_end_date >= ? OR validity_end_date IS NULL)) OR
                    (validity_start_date >= ? AND (validity_end_date <= ? OR validity_end_date IS NULL))",
                    record.validity_start_date, record.validity_start_date,
                    record.validity_start_date, record.validity_end_date,
                  )
                else
                  scope.where(
                    "(validity_start_date <= ? AND (validity_end_date >= ? OR validity_end_date IS NULL))",
                    record.validity_start_date, record.validity_start_date,
                  )
                end

        valid = scope.count.zero?
      end

      valid
    end

  validation :ME17, "If the additional code type has as application 'non-Meursing' then the additional code must exist as a non-Meursing additional code.",
    on: [:create, :update],
    if: -> (record) { record.additional_code_type.present? && record.additional_code_type.non_meursing? } do |record|
      record.additional_code.present?
    end

  validation :ME19,
    %Q(If the additional code type has as application 'ERN' then the goods code must be specified
    but the order number is blocked for input.),
    on: [:create, :update],
    if: ->(record) { record.additional_code_type.present? && record.additional_code_type.application_code.in?("0") } do |record|
      record.goods_nomenclature_item_id.present? && record.ordernumber.blank?
    end

  validation :ME21,
    %Q(If the additional code type has as application 'ERN' then the combination of goods code + additional code
    must exist as an ERN product code and its validity period must span the validity period of the measure),
    on: [:create, :update],
    if: ->(record) {
      record.additional_code_type.present? &&
      record.additional_code_type.application_code.present? &&
      record.additional_code_type.application_code.in?("0") &&
      record.goods_nomenclature_item_id.present? && record.additional_code.present?
    } do
      validates :validity_date_span, of: :additional_code_type, extend_message: true
    end

  #validation :ME24, 'The role + regulation id must exist. If no measure start date is specified it defaults to the regulation start date.', on: [:create, :update] do
    #validates :presence, of: [:measure_generating_regulation_id, :measure_generating_regulation_role]
  #end

  validation :ME25, "If the measure's end date is specified (implicitly or explicitly) then the start date of the measure must be less than or equal to the end date.",
      on: [:create, :update],
      if: ->(record) { (record.national? && !record.invalidated?) || !record.national? } do
        validates :validity_dates
      end

  validation :ME26, 'The entered regulation may not be completely abrogated.' do
    validates :exclusion, of: [:measure_generating_regulation_id,
                               :measure_generating_regulation_role],
                          from: -> { CompleteAbrogationRegulation.select(:complete_abrogation_regulation_id,
                                                                         :complete_abrogation_regulation_role)
                                   }
  end

  validation :ME27, 'The entered regulation may not be fully replaced.', on: [:create, :update] do |record|
    record.generating_regulation.present? && !record.generating_regulation.fully_replaced?
  end

  validation :ME29, 'If the entered regulation is a modification regulation then its base regulation may not be completely abrogated.', on: [:create, :update] do |record|
    (record.generating_regulation.is_a?(ModificationRegulation) && record.modification_regulation.base_regulation.not_completely_abrogated?) ||
    (!record.generating_regulation.is_a?(ModificationRegulation))
  end

  validation :ME32,
    %(There may be no overlap in time with other measure occurrences with a goods code in the
     same nomenclature hierarchy which references the same measure type, geo area, order number,
     additional code and reduction indicator. This rule is not applicable for Meursing additional
     codes.),
     on: [:create, :update],
     extend_message: ->(record) { record.measure_sid.present? ? "{ measure_sid=>\"#{record.measure_sid}\" }" : nil },
     if: ->(record) { record.additional_code.present? && record.additional_code_type.present? && record.additional_code_type.non_meursing? } do |record|
       record.duplicates_by_attributes.count.zero?
     end

  validation [:ME33, :ME34], %q{A justification regulation may not be entered if the measure end date is not filled in
                                A justification regulation must be entered if the measure end date is filled in.}, on: [:create, :update] do |record|
     (record[:validity_end_date].blank? &&
      record.justification_regulation_id.blank? &&
      record.justification_regulation_role.blank?) ||
     (record[:validity_end_date].present? &&
      record.justification_regulation_id.present? &&
      record.justification_regulation_role.present?)
  end

  validation :ME39, "The validity period of the measure must span the validity period of all related partial temporary stop (PTS) records.", on: [:create, :update] do
    validates :validity_date_span, of: :measure_partial_temporary_stops
  end

  #
  # NEED_TO_CHECK
  #
  # validation :ME40,
  #   %(If the flag "duty expression" on measure type is "mandatory" then at least one measure component
  #   or measure condition component record must be specified. If the flag is set "not permitted" then
  #   no measure component or measure condition component must exist. Measure components and measure
  #   condition components are mutually exclusive. A measure can have either components or condition
  #   components (if the ‘duty expression’ flag is ‘mandatory’ or ‘optional’) but not both.),
  #   on: [:create, :update] do |record|
  #     valid = true

  #     if record.measure_type.try(:measure_component_applicable_code) == 1 # mandatory
  #       valid = !record.measure_components.empty? || record.measure_conditions.any? { |mc| !mc.measure_condition_components.empty? }
  #     end

  #     if record.measure_type.try(:measure_component_applicable_code) == 2 # not permitted
  #       valid = record.measure_components.empty? && record.measure_conditions.all? { |mc| mc.measure_condition_components.empty? }
  #     end

  #     valid
  #   end

  validation :ME86, 'The role of the entered regulation must be a Base, a Modification, a Provisional Anti-Dumping, a Definitive Anti-Dumping.', on: [:create, :update] do
    validates :inclusion, of: :measure_generating_regulation_role, in: Measure::VALID_ROLE_TYPE_IDS
  end

  # validation :ME87,
  #   %(The validity period of the measure (implicit or explicit) must reside
  #   within the effective validity period of its supporting regulation. The
  #   effective validity period is the validity period of the regulation taking
  #   into account extensions and abrogation.), on: [:create, :update] do |record|

  #   valid = record.validity_start_date.present?

  #   if valid
  #     if record.validity_end_date.present? && record.generating_regulation_id.present
  #       generating_regulation = record.generating_regulation

  #       regulation_start_date = generating_regulation.validity_start_date
  #       regulation_end_date   = generating_regulation.effective_end_date.presence ||
  #                               generating_regulation.validity_end_date

  #         valid = (regulation_start_date <= record.validity_start_date) &&
  #                 (regulation_end_date >= record.validity_end_date)
  #     end
  #   end

  #   valid
  # end

  validation :ME88, 'The level of the goods code, if present, cannot exceed the explosion level of the measure type.', on: [:create, :update] do |record|
    # NOTE wont apply to national invalidates Measures
    # Taric may delete a Goods Code and national measures will be invalid.
    # TODO is not applicable for goods indent numbers above 10?
    (record.national? && record.invalidated?) ||
    (record.goods_nomenclature.blank? && record.export_refund_nomenclature.blank?) ||
    (record.measure_type.present? &&
    (record.goods_nomenclature.present? &&
     record.goods_nomenclature.number_indents.present? &&
     (record.goods_nomenclature.number_indents > 10 ||
     record.goods_nomenclature.number_indents <= record.measure_type.measure_explosion_level)) ||
     (record.export_refund_nomenclature.present? &&
      record.export_refund_nomenclature.number_indents.present? &&
      (record.export_refund_nomenclature.number_indents > 10 ||
       record.export_refund_nomenclature.number_indents <= (record.measure_type.measure_explosion_level))))
  end

  validation :ME104,
    %(The justification regulation must be either:
      - the measure’s measure-generating regulation, or
      - a measure-generating regulation, valid on the day after the measure’s (explicit) end date.
      If the measure’s measure-generating regulation is ‘approved’, then so must be the justification regulation) do |record|

    valid = true

    justification_regulation_present = record.justification_regulation_id.present? &&
                                       record.justification_regulation.present?

    if justification_regulation_present
      # CASE 1:
      #
      # The justification regulation must be either the measure’s measure-generating regulation
      #
      valid = record.justification_regulation_id == record.measure_generating_regulation_id &&
              record.justification_regulation_role == record.measure_generating_regulation_role
    end

    # puts ""
    # puts " VALID after CASE 1: #{valid}"
    # puts ""

    # CASE 2:
    #
    # OR measure-generating regulation should be valid on the day after the measure’s (explicit) end date.
    #

    unless valid
      if record.measure_generating_regulation_id.present?
        if record.generating_regulation.validity_end_date.present? &&
            record.validity_end_date.present?

          # puts ""
          # puts "CASE 2-1"
          # puts ""

          valid = record.generating_regulation.validity_end_date > record.validity_end_date

        else
          # puts ""
          # puts "CASE 2-2"
          # puts ""
          # puts " record.validity_end_date: #{record.validity_end_date}"
          # puts ""
          # puts " record.generating_regulation.validity_end_date: #{record.generating_regulation.validity_end_date}"
          # puts ""

          # This means measure is valid record as its validity end date is `nil`
          valid = (
            record.validity_end_date.blank? &&
            record.generating_regulation.validity_end_date.blank?
          )
        end
      end
    end

    # puts ""
    # puts " VALID after CASE 2: #{valid}"
    # puts ""

    unless valid
      if justification_regulation_present
        # CASE 3:
        # If the measure’s measure-generating regulation is ‘approved’,
        # then so must be the justification regulation
        #
        # In other words: both should have `approved_flag`
        #
        unless valid
          if record.measure_generating_regulation_id.present?
            valid = record.generating_regulation.approved_flag.present? &&
              record.justification_regulation.approved_flag.present?
          end
        end
      end
    end

    # puts ""
    # puts " VALID after CASE 3: #{valid}"
    # puts ""

    valid
  end

  validation :ME112, "If the additional code type has as application 'Export Refund for Processed Agricultural Goods' then the measure does not require a goods code.",
    on: [:create, :update],
    if: ->(record) { record.additional_code_type.present? && record.additional_code_type.application_code.in?("4") } do |record|
      record.goods_nomenclature_item_id.blank?
    end

  validation :ME113, "If the additional code type has as application 'Export Refund for Processed Agricultural Goods' then the additional code must exist as an Export Refund for Processed Agricultural Goods additional code.",
    on: [:create, :update],
    if: ->(record) { record.additional_code_type.present? && record.additional_code_type.application_code.in?("4") } do |record|
      record.additional_code_id.present? && (record.additional_code.additional_code_type_id == additional_code_type.additional_code_type_id)
    end

  validation :ME115, 'The validity period of the referenced additional code must span the validity period of the measure', on: [:create, :update] do
    validates :validity_date_span, of: :additional_code, extend_message: true
  end

  validation :ME116, 'When a quota order number is used in a measure then the validity period of the quota order number must span the validity period of the measure.  This rule is only applicable for measures with start date after 31/12/2007.',
    on: [:create, :update],
    if: ->(record) {
      record.validity_start_date.present? &&
      record.validity_start_date > Date.new(2007,12,31) &&
      record.order_number.present? && record.ordernumber =~ /^09[012356789]/
    } do
      # Only quota order numbers managed by the first come first served principle are in scope; these order number are starting with '09'; except order numbers starting with '094'
      validates :validity_date_span, of: :order_number, extend_message: true
    end

  #
  # NEED_TO_CHECK
  #
  # Would not work in Create Quota as here can be multiple origins.
  # Need backend rework
  #
  # validation :ME117,
  #   %{When a measure has a quota measure type then rhe origin must exist as a quota order number origin.
  #     This rule is only applicable for measures with start date after 31/12/2007. Only origins for quota
  #     order numbers managed by the first come first served principle are in scope; these order number are
  #     starting with '09'; except order numbers starting with '094'},
  #   on: [:create, :update],
  #   if: ->(record) {
  #     ( record.validity_start_date > Date.new(2007,12,31) ) && (
  #       record.ordernumber.present? && record.ordernumber[0,2] == "09" && record.ordernumber[0,3] != "094"
  #     )
  #   } do |record|
  #     record.quota_order_number.present? && record.quota_order_number.quota_order_number_origin.present?
  #   end

  validation :ME118,
    %(When a quota order number is used in a measure then the validity period of the quota order number must
     span the validity period of the measure. This rule is only applicable for measures with start date after
     31/12/2007. Only quota order numbers managed by the first come first served principle are in scope;
     these order number are starting with '09'; except order numbers starting with '094'),
    on: [:create, :update],
    if: ->(record) {
      (record.validity_start_date > Date.new(2007,12,31)) &&
      (record.order_number.present? && record.ordernumber =~ /^09[012356789]/) &&
      (record.ordernumber[0,2] == "09" && record.ordernumber[0,3] != "094")
    } do
      validates :validity_date_span, of: :order_number, extend_message: true
  end

  validation :ME119,
    %(When a quota order number is used in a measure then the validity period of the quota order number origin must
     span the validity period of the measure. This rule is only applicable for measures with start date after
     31/12/2007. Only origins for quota order numbers managed by the first come first served principle are in scope;
     these order number are starting with '09'; except order numbers starting with '094'),
     if: ->(record) {
       (record.validity_start_date > Date.new(2007,12,31)) &&
       (record.order_number.present? && record.ordernumber =~ /^09[012356789]/) &&
       (record.ordernumber[0,2] == "09" && record.ordernumber[0,3] != "094") &&
       (record.quota_order_number_origin.present?)
     } do
       validates :validity_date_span, of: :quota_order_number_origin, extend_message: true
  end
end
