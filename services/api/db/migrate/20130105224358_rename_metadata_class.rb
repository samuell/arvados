class RenameMetadataClass < ActiveRecord::Migration
  def up
    rename_column :metadata, :metadatum_class, :metadata_class
  end

  def down
    rename_column :metadata, :metadata_class, :metadatum_class
  end
end
