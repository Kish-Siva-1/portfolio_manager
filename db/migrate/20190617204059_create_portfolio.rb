class CreatePortfolio < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.string  :user_id
      t.string  :name
    end
  end
end
