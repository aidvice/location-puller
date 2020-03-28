class CreateStateCases < ActiveRecord::Migration[6.0]
  def change
    create_table :state_cases do |t|
      t.string :state_long_name
      t.string :state_short_name
      t.integer :confirmed_cases
      t.integer :suspicious_cases
      t.integer :no_of_deaths

      t.timestamps
    end
  end
end
