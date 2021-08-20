class CouponsController < ApplicationController
  include LineConcern
  # GET /welcome
  def index
    @coupons = Coupon.all
  end

  def create
    users = User.where(enable: true)
    users.each do |user|
      response = GajoenApi.create_tickets(brand_id: 145, item_id: 56509)
      Coupon.create(user_id: user.id, item_id: response['item_id'], brand_id: response['brand_id'], coupon_url: response['url'], request_code: response['request_code'])
      message = {
        type: 'text',
        text: "日頃の感謝を込めてクーポンを配信します！是非お使いください！\n#{response['url']}"
      }
      client.push_message(user.line_id, message)
    end
    flash[:notice] = "#{users.count}件クーポンを配信しました。"
    redirect_to controller: :welcome
  end
end
