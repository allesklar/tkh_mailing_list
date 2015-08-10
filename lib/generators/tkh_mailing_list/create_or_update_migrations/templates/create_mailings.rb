class CreateMailings < ActiveRecord::Migration

  def self.up
    create_table :mailings do |t|
      t.string :title
      t.string :subject
      t.text :body_text
      t.text :body_html
      t.boolean :testing, default: true
      t.text :admin_note

      t.timestamps
    end
    Mailing.create_translation_table! title: :string, subject: :string, body_text: :text, body_html: :text
  end

  def self.down
    drop_table :mailings
    Mailing.drop_translation_table!
  end

end
