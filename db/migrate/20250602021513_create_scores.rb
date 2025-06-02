class CreateScores < ActiveRecord::Migration[8.0]
  def change
    create_table :scores do |t|
      t.string :user_name
      t.string :score_type
      t.float :wpm
      t.float :accuracy
      t.float :time_taken
      t.datetime :completed_at

      t.timestamps
    end
  end
end
