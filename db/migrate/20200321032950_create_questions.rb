class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|

      t.string :description, null: false
      t.string :answer, null: false
      t.boolean :score_second, null: false, default: false
      t.references :question_set, index: true

      t.timestamps
    end
  end
end
