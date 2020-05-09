require "./connect_db.rb"
connect_db!

ActiveRecord::Migration.create_table(:menus) do |t|
  t.column :name, :text
end
