class CreateStock < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string  :name
      t.string  :description
    end
  end
end
