class CreateRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.column :parent_type, :string
      t.column :parent_id,   :integer
      
      t.column :child_type,  :string
      t.column :child_id,    :integer
      
      t.column :user_id, :integer
    end
    
    add_index :relationships, :parent_type
    add_index :relationships, :parent_id
    add_index :relationships, :child_type
    add_index :relationships, :child_id
    add_index :relationships, :user_id
  end

  def self.down
    drop_table :relationships
  end
end