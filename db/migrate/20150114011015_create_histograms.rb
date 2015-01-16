class CreateHistograms < ActiveRecord::Migration
  def change
    create_table :histograms do |t|

      t.integer :dominant_hue
      t.belongs_to :picture
      t.timestamps
    end
    
    add_index :histograms, :picture_id
  end
end