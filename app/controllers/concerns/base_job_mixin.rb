module BaseJobMixin
  extend ActiveSupport::Concern

  included do
    expose(:collection) do
      "#{klass}Decorator".constantize.decorate_collection(
        klass.reverse_order(:issue_date)
             .page(params[:page])
      )
    end

    expose(:additional_params) do
      {}
    end
  end

  def create
    record = klass.new(
      {
        issue_date: Time.zone.now,
        state: "P"
      }.merge(additional_params)
    )
    if persist_record(record)
      worker_klass.perform_async(record.id) unless Rails.env.test?

      redirect_to redirect_url,
                  notice: "#{record_name} was successfully scheduled. Please wait!"
    else
      redirect_to redirect_url,
                  notice: "Something wrong!"
    end
  end
end
