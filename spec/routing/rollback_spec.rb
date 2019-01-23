require 'rails_helper'

RSpec.describe "db/rollbacks routing" do
  before { reload_routes(production) }

  after { reload_routes(false) }

  context "in a non-production environment" do
    let(:production) { false }

    it "GET /db/rollbacks routes to db/rollbacks/index" do
      expect(get: "/db/rollbacks").to route_to(controller: "db/rollbacks", action: "index")
    end

    it "POST /db/rollbacks routes to db/rollbacks/create" do
      expect(post: "/db/rollbacks").to route_to(controller: "db/rollbacks", action: "create")
    end
  end

  context "in production environment" do
    let(:production) { true }

    it "GET /db/rollbacks is not routable" do
      expect(get: "/db/rollbacks").not_to be_routable
    end

    it "POST /db/rollbacks is not routable" do
      expect(post: "/db/rollbacks").not_to be_routable
    end
  end

  def reload_routes(production)
    expect(TradeTariffBackend).to receive(:production?).and_return(production)
    Rails.application.reload_routes!
  end
end
