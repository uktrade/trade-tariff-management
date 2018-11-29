require 'rails_helper'

RSpec.describe(TradeTariffBackend) do
  include EnvironmentHelper

  # TODO: This code was critical but untested at the time of writing. The
  # underlying implementation requires reworking.
  #
  describe "production?" do
    context "in non-production environment" do
      ["tariffs-uat.cloudapps.digital", "tariffs-dev", "dev", "test", "not-a-real-domain", "dit-alpha"].each do |env|
        it "returns false" do
          with_environment("GOVUK_APP_DOMAIN" => env) do
            expect(described_class.production?).to be false
          end
        end
      end
    end

    context "in production environment" do
      it "returns false" do
        with_environment("GOVUK_APP_DOMAIN" => "tariff-management-production.cloudapps.digital") do
          expect(described_class.production?).to be true
        end
      end
    end
  end
end
