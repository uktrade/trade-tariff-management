Sequel.migration do
  change do

    create_table :session_audits do
      primary_key :id
      Integer :user_id
      String :uid
      String :name
      String :email
      String :action

      Time :updated_at
      Time :created_at
    end

  end
end
