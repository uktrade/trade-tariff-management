require "rails_helper"

describe "Measure Saver: Saving of Duty expressions" do

  include_context "measure_saver_base_context"

  let(:duty_expressions) do
    measure.reload
           .measure_components
  end

  before do
    base_regulation
    measure_type
    additional_code
    geographical_area
    commodity
    duty_expression
    monetary_unit
    measurement_unit
    measurement_unit_qualifier

    measure_saver.valid?
    measure_saver.persist!
  end

  # describe "Invalid params" do
  #   let(:ops) do
  #     base_ops.merge(
  #       duty_expressions: {
  #         "0" => {
  #           "duty_expression_type_id"=>"CA",
  #           "description"=>""
  #         },
  #         "1" => {
  #           "duty_expression_type_id"=>"CG",
  #           "description"=>""
  #         }
  #       }
  #     )
  #   end

  #   it "should not create new duty_expressions" do
  #     expect(measure.reload.new?).to be_falsey

  #     expect(MeasureComponent.count).to be_eql(0)
  #     expect(duty_expressions.size).to be_eql(0)
  #   end
  # end

  let(:measure_components_ops) do
    {
      measure_components: {
        "0" => {
          duty_expression_id: "01",
          amount: "10"
        },
        "1" => {
          duty_expression_id: "01",
          amount: "10",
          measurement_unit_code: "DTN",
          measurement_unit_qualifier_code: "X",
          monetary_unit_code: "EUR"
        }
      }
    }
  end

  describe "Successful saving" do
    let(:ops) do
      base_ops.merge(
        measure_components_ops
      )
    end

    it "should create and associate duty_expressions with measure" do
      expect(measure.reload.new?).to be_falsey

      expect(MeasureComponent.count).to be_eql(2)

      expect_duty_expression_to_be_valid(0)
      expect_duty_expression_to_be_valid(1)
    end
  end

  private

    def expect_duty_expression_to_be_valid(position)
      record = duty_expressions[position]
      ops = measure_components_ops[:measure_components][position]

      expect(duty_expression.measure_sid).to be_eql(measure.measure_sid)
      expect(duty_expression.duty_expression_id).to be_eql(ops[:duty_expression_id])
      expect(duty_expression.duty_amount.to_f).to be_eql(ops[:amount].to_s)
      expect(duty_expression.monetary_unit_code).to be_eql(ops[:monetary_unit_code])
      expect(duty_expression.measurement_unit_code).to be_eql(ops[:measurement_unit_code])
      expect(duty_expression.measurement_unit_qualifier_code).to be_eql(
        ops[:measurement_unit_qualifier_code]
      )

      expect(date_to_s(duty_expression.operation_date)).to be_eql(
        date_to_s(measure.operation_date)
      )

      expect(duty_expression.added_at).not_to be_nil
      expect(duty_expression.added_by_id).to be_eql(user.id)
    end
end
