class User < Sequel::Model
  include GDS::SSO::User

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

  module Permissions
    SIGNIN = 'signin'.freeze
    HMRC_EDITOR = 'HMRC Editor'.freeze
    GDS_EDITOR = 'GDS Editor'.freeze
  end

  def self.find_for_gds_oauth(auth_hash)
    user_params = user_params_from_auth_hash(auth_hash)

    # update details of existing user
    if user = find(uid: auth_hash["uid"])
      user.update_attributes(user_params)
    else # Create a new user.
      create(user_params)
    end
  end

  def self.user_params_from_auth_hash(auth_hash)
    GDS::SSO::User.user_params_from_auth_hash(auth_hash.to_hash)
  end

  def self.find_by_uid(uid)
    find(uid: uid)
  end

  def self.create!(attrs)
    create(attrs)
  end

  def gds_editor?
    has_permission?(Permissions::GDS_EDITOR)
  end

  def hmrc_editor?
    has_permission?(Permissions::HMRC_EDITOR)
  end

  def approver?
    #
    # FIXME
    #
    true # approver_user.present?
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

  def workbaskets_queue
    WorkbasketsSearch.new(
      self
    ).results
  end

  def next_workbasket_to_cross_check
    workbaskets_queue.cross_check_can_be_started
                     .first
  end

  def next_workbasket_to_approve
    workbaskets_queue.approve_can_be_started
                     .first
  end
end
