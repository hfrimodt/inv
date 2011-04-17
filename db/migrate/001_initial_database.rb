
#   Examples:
#   Primary key inside this class
#   Foreign key methods in lib/migration_helpers
#   require "migration_helpers"  and extend MigrationHelpers

#require "migration_helpers" 

class InitialDatabase < ActiveRecord::Migration
#  extend MigrationHelpers

  def self.primary_key(table_name)
    execute "alter table #{table_name} add constraint #{table_name}_pk primary key (id)"
  end 

  def self.up
    # force => drop table if already exists
	# :id => false, because I want to add named primary key. No primary key sequence generated either
 
    create_table :locations, :force => true, :id => true do |t|
      t.column :id,            :integer, :null => false
      t.column :location_name, :string, :null => false, :limit => 100
      t.column :parent_id,     :integer	  
      t.timestamps
    end
	
#	primary_key(:locations)
	
    create_table :categories, :force => true, :id => true do |t|
      t.column :id,            :integer, :null => false
      t.column :category_name, :string, :null => false, :limit => 100
      t.timestamps
    end
	
#	primary_key(:categories)
	
    create_table :suppliers, :force => true, :id => true do |t|
      t.column :id,            :integer, :null => false
      t.column :name,          :string, :null => false, :limit => 100
	  t.column :address,	   :string, :limit => 100
	  t.column :postal_code,	   :integer
	  t.column :city,	       :string, :limit => 60
	  t.column :country,	       :string, :limit => 60
      t.timestamps
    end

#	primary_key(:suppliers)

    create_table :manufacturers, :force => true, :id => true do |t|
      t.column :id,            :integer, :null => false
      t.column :name,          :string, :null => false, :limit => 100
      t.timestamps
    end

#	primary_key(:manufacturers)

    create_table :items, :force => true, :id => true do |t|
      t.column :id,            :integer, :null => false
	  t.column :location_id,     :integer, :null => false
	  t.column :category_id,     :integer, :null => false
	  t.column :supplier_id,     :integer, :null => true
	  t.column :manufacturer_id, :integer, :null => false
      t.column :name,          :string, :null => false, :limit => 100
	  t.column :model,	       :string, :limit => 100
	  t.column :serial_number,  :string, :limit => 100
      t.column :quantity,       :integer
      t.column :price,		   :decimal, :precision => 10, :scale => 2
      t.column :purchase_date,  :date
	  t.column :description,    :text
      t.timestamps
    end

#	primary_key(:items)
	
#	foreign_key(:items, :location_id, :locations)
#    foreign_key(:items, :category_id, :categories)
#    foreign_key(:items, :supplier_id, :suppliers)
#    foreign_key(:items, :manufacturer_id, :manufacturers)

    create_table :documents, :force => true, :id => true do |t|
      t.column :id,            :integer, :null => false
	  t.column :file_name,      :string, :limit => 500
	  t.column :extension,      :string, :limit => 100
	  t.column :filesize,       :integer
	  t.column :document,        :binary
      t.timestamps
    end

#	primary_key(:documents)
	
    create_table :item_documents, :force => true, :id => true do |t|
      t.column :id,            :integer, :null => false
	  t.column :item_id,	   :integer, :null => false
	  t.column :document_id,   :integer, :null => false
	  t.column :status,        :float, :precision => 1
      t.timestamps
    end

#	primary_key(:item_documents)

 #   foreign_key(:item_documents, :item_id, :items)

  #  foreign_key(:item_documents, :document_id, :documents)

	create_table :images, :force => true, :id => true do |t|
      t.column :id,              :integer, :null => false
	  t.column :item_id,		 :integer, :null => false
	  t.column :image_file_data, :binary
      t.timestamps
    end

#	primary_key(:images)

  end

  def self.down
    drop_table :item_documents
    drop_table :documents
    drop_table :images
    drop_table :items
    drop_table :locations
    drop_table :categories
	drop_table :suppliers
	drop_table :manufacturers
  end
end
