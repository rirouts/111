class CreateUploadedDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :uploaded_documents do |t|
      t.references :profile, foreign_key: true

      t.timestamps
    end
  end
end
