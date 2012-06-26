class CreateRegulationRoleTypes < ActiveRecord::Migration
  def change
    create_table :regulation_role_types, :id => false do |t|
      t.string :id
      t.date :validity_start_date
      t.date :validity_end_date

      t.timestamps
    end
  end
end
