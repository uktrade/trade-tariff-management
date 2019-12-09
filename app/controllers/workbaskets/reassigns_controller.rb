module Workbaskets
  class ReassignsController < Workbaskets::BaseController
    skip_around_action :configure_time_machine, only: [:submitted_for_cross_check]

    expose(:sub_klass) {"Reassigns"}

    def new
      @workbasket = Workbaskets::Workbasket.find(id: params[:workbasket_id])
      @users = User.all - [current_user]
    end

    def create
      @workbasket = Workbaskets::Workbasket.find(id: params[:format])
      @workbasket.user_id = params[:user_id]
      @workbasket.save
      @user = User.find(id: params[:user_id])
    end
  end
end
