class CreateDirtyHistoryRecords < ActiveRecord::Migration
  def self.up
    create_table :dirty_history_records do |t|
      t.integer    :creator_id
      t.string     :creator_type, :limit => 64
      t.integer    :asset_id
      t.string     :asset_type,  :limit => 64
      t.string     :column_name,  :limit => 64
      t.string     :column_type,  :limit => 16 # :string, :text, :integer, :decimal, :float, :datetime, :boolean
      t.string     :old_value,    :limit => 128
      t.string     :new_value,    :limit => 128

      t.datetime   :created_at
      t.datetime   :value_changed_at
      t.datetime   :updated_at
      t.datetime   :deleted_at
    end
    add_index :dirty_history_records, [:creator_id, :creator_type]
    add_index :dirty_history_records, [:asset_id,  :asset_type]
    add_index :dirty_history_records, [:created_at,  :value_changed_at], :name => "index_created_at"
    add_index :dirty_history_records, [:deleted_at, :created_at,  :value_changed_at], :name => "index_deleted_at_created_at"
    add_index :dirty_history_records, [:asset_type, :column_name, :deleted_at], :name => "index_obj_type_column_deleted_at"
    add_index :dirty_history_records, [:asset_type, :column_name, :deleted_at, :created_at, :value_changed_at], :name => "index_obj_type_column_deleted_at_created_at"

    add_index :dirty_history_records, :old_value, :name => "index_old_value"
    add_index :dirty_history_records, :new_value, :name => "index_new_value"
    add_index :dirty_history_records, [:old_value, :new_value], :name => "index_old_value_new_value"
  end

  def self.down
    drop_table :dirty_history_records
  end
end