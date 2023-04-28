class AddPublisherToNews < ActiveRecord::Migration[7.0]
  def change
    add_reference :news, :publisher, null: false, foreign_key: true
  end
end
