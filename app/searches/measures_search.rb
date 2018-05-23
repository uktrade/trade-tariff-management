class MeasuresSearch

  # search: {
  #   group_name: {
  #      operator: 'is',
  #      value: 'user input'
  #   },

  #   status: {
  #      operator: 'is',
  #      value: 'downcase and separated with underscores abbreviation of status' (eg: 'draft_incomplete', 'cross_check_rejected')
  #   },

  #   author: {
  #      operator: 'is',
  #      value: 'selected user id' (eg: '1', '2')
  #   },

  #   date_of: {
  #      operator: 'is',
  #      mode: 'creation' (or 'authoring' / 'last_status_change')
  #      value: 'selected date'  (eg: '16/04/2018')
  #   },

  #   last_updated_by: {
  #      operator: 'is',
  #      value: 'selected user id' (eg: '1', '2')
  #   },

  #   regulation: {
  #      operator: 'is',
  #      value: 'user input'
  #   },

  #   type: {
  #      operator: 'is',
  #      value: 'selected measure type id' ('VTZ"')
  #   },

  #   valid_from: {
  #      operator: 'is',
  #      value: 'selected date'  (eg: '16/04/2018')
  #   },

  #   valid_to: {
  #      operator: 'is',
  #      value: 'selected date'  (eg: '16/04/2018')
  #   },

  #   commodity_code: {
  #      operator: 'is',
  #      value: 'user input'
  #   },

  #   additional_code: {
  #      operator: 'is',
  #      value: 'user input'
  #   },

  #   origin: {
  #      operator: 'is',
  #      value: 'selected geographical area id' (eg: '485')
  #   },

  #   origin_exclusions: {
  #      operator: 'include',
  #      value: [
  #         '495',
  #         '546'
  #      ] (eg: array of geographical area IDs)
  #   },

  #   duties: {
  #      operator: 'include',
  #      value: [
  #         { '99' => '10' },
  #         { '01' => '15' },
  #      ] (eg: array of hashes, where key (eg: '99') is duty_expression_id and value is 'user input')
  #   },

  #   conditions: {
  #      operator: 'include',
  #      value: [
  #         'A',
  #         'B'
  #      ] (eg: array of selected measure condition codes')
  #   },

  #   footnotes: {
  #      operator: 'include',
  #      value: [
  #         { 'WR' => '101' },
  #         { 'AR' => '234' },
  #      ] (eg: array of hashes, where key (eg: 'WR') is footnote_type_id and value is 'user input aka footnote id')
  #   },
  # }

  #
  # "are not specified" means IS NULL
  #
  # "are not unspecified" means "IS NOT NULL"
  #

  ALLOWED_FILTERS = %w(
    group_name
    status
    author
    date_of
    last_updated_by
    regulation
    type
    valid_from
    valid_to
    commodity_code
    additional_code
    origin
    origin_exclusions
    duties
    conditions
    footnotes
  )

  attr_accessor *([:search_ops, :page] + ALLOWED_FILTERS)

  def initialize(search_ops)
    @search_ops = search_ops
    @page = search_ops[:page] || 1
  end

  def results
    @relation = Measure.default_search
    @relation = relation.operation_search_jsonb_default if jsonb_search_required?

    search_ops.select do |k, v|
      ALLOWED_FILTERS.include?(k.to_s) && v.present?
    end.each do |k, v|
      instance_variable_set("@#{k}", search_ops[k])
      send("apply_#{k}_filter")
    end

    relation.page(page)
            .by_start_date_desc
  end

  private

    def jsonb_search_required?
      group_name ||
      origin_exclusions ||
      duties ||
      conditions ||
      footnotes
    end

    def apply_group_name_filter
      @relation = relation.operator_search_by_group_name(
        query_ops(group_name)
      )
    end

    def apply_status_filter
      @relation = relation.operator_search_by_status(status, operator)
    end

    def apply_author_filter
      @relation = relation.operator_search_by_author(author)
    end

    def apply_date_of_filter
      # TODO
      @relation = relation.operator_search_by_date_of(date_of)
    end

    def apply_last_updated_by_filter
      @relation = relation.operator_search_by_last_updated_by(last_updated_by)
    end

    def apply_regulation_filter
      @relation = relation.operator_search_by_regulation(regulation, operator)
    end

    def apply_type_filter
      @relation = relation.operator_search_by_measure_type(type, operator)
    end

    def apply_valid_from_filter
      @relation = relation.operator_search_by_valid_from(
        query_ops(valid_from)
      )
    end

    def apply_valid_to_filter
      @relation = relation.operator_search_by_valid_to(
        query_ops(valid_to)
      )
    end

    def apply_commodity_code_filter
      @relation = relation.operator_search_by_commodity_code(
        query_ops(commodity_code)
      )
    end

    def apply_additional_code_filter
      @relation = relation.operator_search_by_additional_code(
        query_ops(additional_code)
      )
    end

    def apply_origin_filter
      @relation = relation.operator_search_by_origin(
        query_ops(origin)
      )
    end

    def apply_origin_exclusions_filter
      @relation = relation.operator_search_by_origin_exclusions(
        query_ops(origin_exclusions)
      )
    end

    def apply_duties_filter
      @relation = relation.operator_search_by_duties(
        query_ops(duties)
      )
    end

    def apply_conditions_filter
      @relation = relation.operator_search_by_conditions(
        query_ops(conditions)
      )
    end

    def apply_footnotes_filter
      @relation = relation.operator_search_by_footnotes(
        query_ops(footnotes)
      )
    end

    def query_ops(ops)
      *[
        ops[:operator],
        ops[:value]
      ]
    end
end
