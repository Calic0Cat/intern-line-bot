class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :line_id, :null => false, :unique => true
      t.string :name
      t.string :sex
      t.integer :age
      t.string :like
      t.boolean :enable, :default => true

      t.timestamps
    end
  end
end
