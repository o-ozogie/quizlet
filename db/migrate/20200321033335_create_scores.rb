class CreateScores < ActiveRecord::Migration[6.0]
  def change
    create_table :scores do |t|

      t.boolean :result, null: false
      t.string :submit_answer, null: false
      t.references :user, index: true
      t.references :question, index: true

      t.timestamps
    end
  end
end
