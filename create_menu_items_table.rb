require "./connect_db.rb"
connect_db!

ActiveRecord::Migration.create_table(:menu_items) do |t|
  t.column :name, :text
  t.column :description, :text
  t.column :price, :decimal
end
