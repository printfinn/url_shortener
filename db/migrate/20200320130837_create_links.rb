class CreateLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :links do |t|
      t.string :full_link
      t.string :shortened_link

      t.timestamps
    end
  end
end
