class CreateRankedBallots < ActiveRecord::Migration[7.2]
  def change
    create_table :ranked_ballots do |t|
      t.references :user, null: false, foreign_key: true
      t.references :election, null: false, foreign_key: true
      t.text :rankings

      t.timestamps
    end
  end
end
