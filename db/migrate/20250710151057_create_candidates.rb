class CreateCandidates < ActiveRecord::Migration[7.2]
  def change
    create_table :candidates do |t|
      t.string :name
      t.references :election, null: false, foreign_key: true

      t.timestamps
    end
  end
end
