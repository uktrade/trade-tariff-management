module ForceValidatorConcern
  extend ActiveSupport::Concern

  def force_check_of_validation_rules!
    validator = ("#{self.class.name}Validator").constantize.new
    validator.validate(self)
  end
end
