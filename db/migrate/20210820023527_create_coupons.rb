class CreateCoupons < ActiveRecord::Migration[6.0]
  def change
    create_table :coupons do |t|
      t.references :user, foreign_key: true
      t.string :item_id, :null => false
      t.string :brand_id, :null => false
      t.string :request_code, :null => false, :unique => true
      t.string :coupon_url, :null => false, :unique => true

      t.timestamps
    end
  end
end
