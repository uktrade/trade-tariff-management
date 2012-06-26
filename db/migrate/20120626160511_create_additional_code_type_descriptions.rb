class CreateAdditionalCodeTypeDescriptions < ActiveRecord::Migration
  def change
    create_table :additional_code_type_descriptions, :id => false do |t|
      t.string :id
      t.string :additional_code_type_id
      t.string :language_id
      t.text :short_description

      t.timestamps
    end
  end
end
