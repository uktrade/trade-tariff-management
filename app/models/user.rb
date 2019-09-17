class User < Sequel::Model

  plugin :serialization

  serialize_attributes :yaml, :permissions

  one_to_many :workbaskets, key: :user_id,
                            class_name: "Workbaskets::Workbasket"

  one_to_many :workbasket_events, key: :user_id,
                                  class_name: "Workbaskets::Event"

  dataset_module do
    def approvers
      where(approver_user: true)
    end

    def managers
      where(approver_user: false)
    end

    def q_search(filter_ops)
      q_rule = "#{filter_ops[:q]}%"

      where(
        "name ilike ? OR email ilike ?",
        q_rule, q_rule
      ).order(:name)
    end
  end

  # find user from SSO auth data (uid)
  # create the user if doesn't exist
  # NB user would be created with access disabled
  def self.from_omniauth(auth)

    if user = find(uid: auth.uid)
      Rails.logger.debug "user exists in system"
    else
      Rails.logger.debug "user does not exist in system"
      Rails.logger.debug user_params_from_auth(auth)
      user = create(user_params_from_auth(auth))
    end

    # return the found user or newly created user
    user
  end

  def self.user_params_from_auth(auth)

    # combine first & last names into name for User model
    name = auth.info.first_name.to_s + " " + auth.info.last_name.to_s
    # return a set of parameters to create the user record
    {
        'uid' => auth.uid,
        'email' => auth.info.email,
        # perhaps add these separate fields in the future?
        # 'first_name' => auth.first_name,
        # 'last_name' => auth.last_name,
        'name' => name,
        'disabled' => true      # user access is disabled by default
    }

  end


  def self.find_by_uid(uid)
    find(uid: uid)
  end

  def self.create!(attrs)
    create(attrs)
  end

  def approver?
    approver_user.present?
  end

  def remotely_signed_out?
    remotely_signed_out
  end

  def disabled?
    disabled
  end

  def update_attribute(attribute, value)
    update(attribute => value)
  end

  def update_attributes(attributes)
    update(attributes)
    self
  end

  def json_mapping
    {
      id: id,
      name: name
    }
  end

  def to_json
    json_mapping
  end

  def author_of_workbasket?(workbasket)
    workbasket.user_id == id
  end

  def next_workbasket_to_cross_check(current_workbasket)
    WorkbasketsSearch.new(
      self
    ).next_workbasket('awaiting_cross_check', current_workbasket).first
  end

  def next_workbasket_to_approve(current_workbasket)
    WorkbasketsSearch.new(
      self
    ).next_workbasket('awaiting_approval', current_workbasket).first
  end
end
