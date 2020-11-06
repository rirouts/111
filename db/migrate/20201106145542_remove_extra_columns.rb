class RemoveExtraColumns < ActiveRecord::Migration[5.2]
  def change
    # These columns were erroneously added (likely via a bad command line generate migration)
    remove_column :resource_histories, :boolean, :boolean
    remove_column :resource_histories, :jsonb, :jsonb
    remove_column :resources, :boolean, :boolean, default: false, null: false
    remove_column :resources, :jsonb, :jsonb
  end
end
