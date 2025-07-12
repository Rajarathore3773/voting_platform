class CreateDelegations < ActiveRecord::Migration[7.2]
  def change
    create_table :delegations do |t|
      t.references :election, null: false, foreign_key: true
      t.integer :delegator_id
      t.integer :delegate_id

      t.timestamps
    end
  end
end
