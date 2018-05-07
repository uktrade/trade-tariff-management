require "rails_helper"

describe "Measure Saver: Saving of Quota definitions" do

  include_context "measure_saver_base_context"

  let(:ae_area) do
    create(:geographical_area,
      geographical_area_id: "AE",
      validity_start_date: 1.year.ago
    )
  end

  let(:ag_area) do
    create(:geographical_area,
      geographical_area_id: "AG",
      validity_start_date: 1.year.ago
    )
  end

  let(:order_number_ops) do
    {
      existing_quota: "false",
      quota_status: "open",
      quota_ordernumber: "090716",
      quota_criticality_threshold: "15",
      quota_description: "Test description",
      geographical_area_id: geographical_area.geographical_area_id,
      excluded_geographical_areas: [
        ae_area.geographical_area_id, ag_area.geographical_area_id
      ]
    }
  end

  before do
    base_regulation
    measure_type
    additional_code
    geographical_area
    ae_area
    ag_area
    commodity

    measure_saver.valid?
    measure_saver.persist!
  end

  describe "Invalid params (without quota periods)" do
    let(:ops) do
      base_ops.merge(
        order_number_ops
      )
    end

    it "should not create new duty_expressions" do
      expect(measure.reload.new?).to be_falsey

      expect(QuotaOrderNumber.count).to be_eql(0)
      expect(QuotaDefinition.count).to be_eql(0)
    end
  end

  describe "Successful saving" do
    let(:start_period_date) { date_to_s(1.day.from_now) }

    describe "Annual" do
      let(:ops) do
        base_ops.merge(
          order_number_ops
        ).merge(
          quota_periods: {
            annual: {
              "amount1" => "10",
              "start_date" => start_period_date,
              "measurement_unit_code" => "EUR",
              "measurement_unit_qualifier_code" => "X"
            }
          }
        )
      end

      it "should create order number and annual quota defition" do
        expect(measure.reload.new?).to be_falsey

        expect(QuotaOrderNumber.count).to be_eql(1)
        expect(QuotaDefinition.count).to be_eql(1)

        expect_order_number_to_be_valid
        expect_quota_definition_to_be_valid(
          quota_definitions[0],
          10,
          start_period_date.to_date,
          start_period_date.to_date + 1.year,
          ops[:quota_periods][:annual]
        )
      end
    end

    describe "Bi-Annual" do
      let(:ops) do
        base_ops.merge(
          order_number_ops
        ).merge(
          quota_periods: {
            bi_annual: {
              "amount1" => "10",
              "amount2" => "20",
              "start_date"=> start_period_date,
              "measurement_unit_code" => "EUR",
              "measurement_unit_qualifier_code" => "X"
            }
          }
        )
      end

      it "should create order number and bi-annual quota defitions" do
        expect(measure.reload.new?).to be_falsey

        expect(QuotaOrderNumber.count).to be_eql(1)
        expect(QuotaDefinition.count).to be_eql(2)
        expect_order_number_to_be_valid

        expect_quota_definition_to_be_valid(
          quota_definitions[0],
          10,
          start_period_date.to_date,
          start_period_date.to_date + 6.months,
          ops[:quota_periods][:bi_annual]
        )

        expect_quota_definition_to_be_valid(
          quota_definitions[1],
          20,
          start_period_date.to_date + 6.months,
          start_period_date.to_date + 1.year,
          ops[:quota_periods][:bi_annual]
        )
      end
    end

    describe "Quarterly" do
      let(:ops) do
        base_ops.merge(
          order_number_ops
        ).merge(
          quota_periods: {
            quarterly: {
              "amount1" => "10",
              "amount2" => "20",
              "amount3" => "30",
              "amount4" => "40",
              "start_date"=> start_period_date,
              "measurement_unit_code" => "EUR",
              "measurement_unit_qualifier_code" => "X"
            }
          }
        )
      end

      it "should create order number and 1 quota defition per each quarter of year" do
        expect(measure.reload.new?).to be_falsey

        expect(QuotaOrderNumber.count).to be_eql(1)
        expect(QuotaDefinition.count).to be_eql(4)
        expect_order_number_to_be_valid

        expect_quota_definition_to_be_valid(
          quota_definitions[0],
          10,
          start_period_date.to_date,
          start_period_date.to_date + 3.months,
          ops[:quota_periods][:quarterly]
        )

        expect_quota_definition_to_be_valid(
          quota_definitions[1],
          20,
          start_period_date.to_date + 3.months,
          start_period_date.to_date + 6.months,
          ops[:quota_periods][:quarterly]
        )

        expect_quota_definition_to_be_valid(
          quota_definitions[2],
          30,
          start_period_date.to_date + 6.months,
          start_period_date.to_date + 9.months,
          ops[:quota_periods][:quarterly]
        )

        expect_quota_definition_to_be_valid(
          quota_definitions[3],
          40,
          start_period_date.to_date + 9.months,
          start_period_date.to_date + 12.months,
          ops[:quota_periods][:quarterly]
        )
      end
    end

    describe "Monthly" do
      let(:ops) do
        base_ops.merge(
          order_number_ops
        ).merge(
          quota_periods: {
            monthly: {
              "amount1" => "10",
              "amount2" => "20",
              "amount3" => "30",
              "amount4" => "40",
              "amount5" => "50",
              "amount6" => "60",
              "amount7" => "70",
              "amount8" => "80",
              "amount9" => "90",
              "amount10" => "100",
              "amount11" => "110",
              "amount12" => "120",
              "start_date"=> start_period_date,
              "measurement_unit_code" => "EUR",
              "measurement_unit_qualifier_code" => "X"
            }
          }
        )
      end

      it "should create order number and 1 quota defition per each month of year" do
        expect(measure.reload.new?).to be_falsey

        expect(QuotaOrderNumber.count).to be_eql(1)
        expect(QuotaDefinition.count).to be_eql(12)
        expect_order_number_to_be_valid

        expect_quota_definition_to_be_valid(
          quota_definitions[0],
          10,
          start_period_date.to_date,
          start_period_date.to_date + 1.months,
          ops[:quota_periods][:monthly]
        )

        expect_quota_definition_to_be_valid(
          quota_definitions[1],
          20,
          start_period_date.to_date + 1.months,
          start_period_date.to_date + 2.months,
          ops[:quota_periods][:monthly]
        )

        expect_quota_definition_to_be_valid(
          quota_definitions[2],
          30,
          start_period_date.to_date + 2.months,
          start_period_date.to_date + 3.months,
          ops[:quota_periods][:monthly]
        )

        expect_quota_definition_to_be_valid(
          quota_definitions[3],
          40,
          start_period_date.to_date + 3.months,
          start_period_date.to_date + 4.months,
          ops[:quota_periods][:monthly]
        )

        expect_quota_definition_to_be_valid(
          quota_definitions[4],
          50,
          start_period_date.to_date + 4.months,
          start_period_date.to_date + 5.months,
          ops[:quota_periods][:monthly]
        )

        expect_quota_definition_to_be_valid(
          quota_definitions[5],
          60,
          start_period_date.to_date + 5.months,
          start_period_date.to_date + 6.months,
          ops[:quota_periods][:monthly]
        )

        expect_quota_definition_to_be_valid(
          quota_definitions[6],
          70,
          start_period_date.to_date + 6.months,
          start_period_date.to_date + 7.months,
          ops[:quota_periods][:monthly]
        )

        expect_quota_definition_to_be_valid(
          quota_definitions[7],
          80,
          start_period_date.to_date + 7.months,
          start_period_date.to_date + 8.months,
          ops[:quota_periods][:monthly]
        )

        expect_quota_definition_to_be_valid(
          quota_definitions[8],
          90,
          start_period_date.to_date + 8.months,
          start_period_date.to_date + 9.months,
          ops[:quota_periods][:monthly]
        )

        expect_quota_definition_to_be_valid(
          quota_definitions[9],
          100,
          start_period_date.to_date + 9.months,
          start_period_date.to_date + 10.months,
          ops[:quota_periods][:monthly]
        )

        expect_quota_definition_to_be_valid(
          quota_definitions[10],
          110,
          start_period_date.to_date + 10.months,
          start_period_date.to_date + 11.months,
          ops[:quota_periods][:monthly]
        )

        expect_quota_definition_to_be_valid(
          quota_definitions[11],
          120,
          start_period_date.to_date + 11.months,
          start_period_date.to_date + 12.months,
          ops[:quota_periods][:monthly]
        )
      end
    end

    describe "Custom" do
      let(:ops) do
        base_ops.merge(
          order_number_ops
        ).merge(
          quota_periods: {
            custom: {
              "0" => {
                "amount1" => "10",
                "start_date"=> start_period_date,
                "end_date" => date_to_s(start_period_date.to_date + 1.year),
                "measurement_unit_code" => "EUR",
                "measurement_unit_qualifier_code" => "X"
              },
              "1" => {
                "amount1" => "20",
                "start_date" => date_to_s(start_period_date.to_date + 1.year),
                "end_date" => date_to_s(start_period_date.to_date + 2.years),
                "measurement_unit_code" => "EUR",
                "measurement_unit_qualifier_code" => "X"
              }
            }
          }
        )
      end

      it "should create order number and custom two quota defitions" do
        expect(measure.reload.new?).to be_falsey

        expect(QuotaOrderNumber.count).to be_eql(1)
        expect(QuotaDefinition.count).to be_eql(2)
        expect_order_number_to_be_valid

        expect_quota_definition_to_be_valid(
          quota_definitions[0],
          10,
          start_period_date.to_date,
          start_period_date.to_date + 1.year,
          ops[:quota_periods][:custom]
        )

        expect_quota_definition_to_be_valid(
          quota_definitions[1],
          20,
          start_period_date.to_date + 1.year,
          start_period_date.to_date + 2.years,
          ops[:quota_periods][:custom]
        )
      end
    end
  end

  private

    def order_number
      measure.reload
             .order_number
    end

    def quota_definitions
      QuotaDefinition.where(
        quota_order_number_id: order_number.quota_order_number_id
      ).order(:validity_start_date)
       .all
    end

    def expect_order_number_to_be_valid
      expect(order_number.quota_order_number_id).to be_eql(measure.ordernumber)

      expect(date_to_s(order_number.validity_start_date)).to be_eql(
        date_to_s(measure.validity_start_date)
      )
      expect(order_number.validity_end_date).to be_nil
      expect(date_to_s(order_number.operation_date)).to be_eql(
        date_to_s(measure.operation_date)
      )

      expect(order_number.added_at).not_to be_nil
      expect(order_number.added_by_id).to be_eql(user.id)

      expect(order_number_origin.geographical_area_id).to be_eql(geographical_area.geographical_area_id)
      expect(excluded_order_number_origin_areas[0].excluded_geographical_area_sid).to be_eql(
        ae_area.geographical_area_sid
      )
      expect(excluded_order_number_origin_areas[1].excluded_geographical_area_sid).to be_eql(
        ag_area.geographical_area_sid
      )
    end

    def order_number_origin
      order_number.quota_order_number_origin
    end

    def excluded_order_number_origin_areas
      QuotaOrderNumberOriginExclusion.where(
        quota_order_number_origin_sid: order_number_origin.quota_order_number_origin_sid
      ).all
    end

    def expect_quota_definition_to_be_valid(record, amount, expected_start_date, expected_end_date, ops)
      expect(record.quota_order_number_id).to be_eql(order_number.quota_order_number_id)
      expect(record.quota_order_number_sid).to be_eql(order_number.quota_order_number_sid)
      expect(record.initial_volume.to_i).to be_eql(amount)

      check_date(record.validity_start_date, expected_start_date)
      check_date(record.validity_end_date, expected_end_date)
      check_date(record.operation_date, measure.operation_date)

      %w(
        monetary_unit_code
        measurement_unit_code
        measurement_unit_qualifier_code
      ).map do |field_name|
        if ops[field_name].present?
          expect(record.public_send(field_name)).to be_eql(ops[field_name])
        end
      end

      expect(record.added_at).not_to be_nil
      expect(record.added_by_id).to be_eql(user.id)
    end

    def check_date(db_value, expected_value)
      expect(
        date_to_s(db_value)
      ).to be_eql(
        date_to_s(expected_value)
      )
    end
end
