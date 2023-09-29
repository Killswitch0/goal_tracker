class CreateChallengeUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :challenge_users do |t|
      t.boolean :confirm, default: false

      t.references :user, null: false, foreign_key: true
      t.references :challenge, null: false, foreign_key: true

      t.timestamps
    end
  end
end
