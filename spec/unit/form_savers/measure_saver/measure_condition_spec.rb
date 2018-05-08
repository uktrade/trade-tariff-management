require "rails_helper"

describe "Measure Saver: Saving of Measure conditions" do

  include_context "measure_saver_base_context"

  let(:measure_conditions) do
    measure.reload
           .measure_conditions
           .sort { |a, b| a.added_at <=> b.added_at }
  end

  before do
    base_regulation
    measure_type
    additional_code
    geographical_area
    commodity
    duty_expression_01
    duty_expression_04
    monetary_unit
    measurement_unit
    measurement_unit_qualifier

    measure_saver.valid?
    measure_saver.persist!
  end

  describe "Invalid params" do
    let(:ops) do
      base_ops.merge(
        conditions: {
          "0" => {
            "condition_code" => "",
            "certificate_code" => ""
          },
          "1" => {
          }
        }
      )
    end

    it "should not create new measure conditions" do
      expect(measure.reload.new?).to be_falsey

      expect(MeasureCondition.count).to be_eql(0)
      expect(measure_conditions.size).to be_eql(0)
    end
  end

  let(:measure_conditions_ops) do
    {
      conditions: {
        "0" =>
          {
            "condition_code" => "B",
            "certificate_type_code" => "C",
            "certificate_code" => "001",
            "action_code" => "01",
            "measure_condition_components" => {
              "0" => {
                "duty_expression_id" => duty_expression_01.duty_expression_id,
                "amount" => "30"
              },
              "1" => {
                "duty_expression_id" => duty_expression_04.duty_expression_id,
                "amount" => "40",
                "measurement_unit_code" => measurement_unit.measurement_unit_code,
                "measurement_unit_qualifier_code" => measurement_unit_qualifier.measurement_unit_qualifier_code,
                "monetary_unit_code" => monetary_unit.monetary_unit_code
              }
            }
        },
        "1" =>
          {
            "condition_code" => "A",
            "certificate_code" => "001",
            "action_code" => "01",
            "measure_condition_components" => {
              "0" => {
                "duty_expression_id" => duty_expression_01.duty_expression_id,
                "amount" => "10"
              },
              "1" => {
                "duty_expression_id" => duty_expression_04.duty_expression_id,
                "amount" => "20",
                "measurement_unit_code" => measurement_unit.measurement_unit_code,
                "measurement_unit_qualifier_code" => measurement_unit_qualifier.measurement_unit_qualifier_code,
                "monetary_unit_code" => monetary_unit.monetary_unit_code
              }
            }
          },
        "2" =>
          {
            "condition_code" => "B",
            "certificate_type_code" => "D",
            "certificate_code" => "005",
            "action_code" => "01",
            "measure_condition_components" => {
              "0" => {
                "duty_expression_id" => duty_expression_01.duty_expression_id,
                "amount" => "30"
              },
              "1" => {
                "duty_expression_id" => duty_expression_04.duty_expression_id,
                "amount" => "40",
                "measurement_unit_code" => measurement_unit.measurement_unit_code,
                "measurement_unit_qualifier_code" => measurement_unit_qualifier.measurement_unit_qualifier_code,
                "monetary_unit_code" => monetary_unit.monetary_unit_code
              }
            }
        },
        "3" =>
          {
            "condition_code" => "B",
            "certificate_type_code" => "A",
            "certificate_code" => "004",
            "action_code" => "01",
            "measure_condition_components" => {
              "0" => {
                "duty_expression_id" => duty_expression_01.duty_expression_id,
                "amount" => "30"
              },
              "1" => {
                "duty_expression_id" => duty_expression_04.duty_expression_id,
                "amount" => "40",
                "measurement_unit_code" => measurement_unit.measurement_unit_code,
                "measurement_unit_qualifier_code" => measurement_unit_qualifier.measurement_unit_qualifier_code,
                "monetary_unit_code" => monetary_unit.monetary_unit_code
              }
            }
        }
      }
    }
  end

  describe "Successful saving" do
    let(:ops) do
      base_ops.merge(
        measure_conditions_ops
      )
    end

    it "should create and associate measure conditions with measure" do
      expect(measure.reload.new?).to be_falsey

      expect(MeasureCondition.count).to be_eql(4)
      expect(MeasureConditionComponent.count).to be_eql(8)

      expect_measure_condition_to_be_valid(0, "0")
      expect_measure_condition_to_be_valid(1, "2")
      expect_measure_condition_to_be_valid(2, "3")
      expect_measure_condition_to_be_valid(3, "1")
    end
  end

  private

    def expect_measure_condition_to_be_valid(position_in_db, position_in_ops)
      record = measure_conditions[position_in_db]
      ops = measure_conditions_ops[:conditions][position_in_ops]

      expect(record.measure_sid).to be_eql(measure.measure_sid)

      record.measure_condition_components
            .sort { |a, b| a.added_at <=> b.added_at }
            .each_with_index do |measure_condition_component, index|

        mc_ops = ops["measure_condition_components"][index.to_s]

        expect(measure_condition_component.duty_expression_id).to be_eql(mc_ops["duty_expression_id"])
        expect(measure_condition_component.duty_amount.to_i).to be_eql(mc_ops["amount"].to_i)
        expect(measure_condition_component.monetary_unit_code).to be_eql(mc_ops["monetary_unit_code"])
        expect(measure_condition_component.measurement_unit_code).to be_eql(mc_ops["measurement_unit_code"])
        expect(measure_condition_component.measurement_unit_qualifier_code).to be_eql(
          mc_ops["measurement_unit_qualifier_code"]
        )
      end

      expect(record.condition_code).to be_eql(ops["condition_code"])
      expect(record.certificate_type_code).to be_eql(ops["certificate_type_code"])
      expect(record.certificate_code).to be_eql(ops["certificate_code"])
      expect(record.action_code).to be_eql(ops["action_code"])

      expect(date_to_s(record.operation_date)).to be_eql(
        date_to_s(measure.operation_date)
      )

      expect(record.added_at).not_to be_nil
      expect(record.added_by_id).to be_eql(user.id)
    end
end
