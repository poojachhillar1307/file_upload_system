class CreateUploadedFiles < ActiveRecord::Migration[8.0]
  def change
    create_table :uploaded_files do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :file_type

      t.timestamps
    end
  end
end
