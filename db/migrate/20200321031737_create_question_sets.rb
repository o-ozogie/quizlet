class CreateQuestionSets < ActiveRecord::Migration[6.0]
  def change
    create_table :question_sets do |t|

      t.string :title, null: false
      t.string :description
      t.boolean :mode, null: false
      t.references :user, index: true

      t.timestamps
    end
  end
end
