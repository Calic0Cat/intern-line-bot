class CouponsController < ApplicationController
  include LineConcern
  # GET /welcome
  def create
    users = User.where(enable: true).pluck(:line_id)
    count = users.count
    users.each do |user|
      response = GajoenApi.create_tickets(brand_id: 145, item_id: 56509)
      message = {
        type: 'text',
        text: "日頃の感謝を込めてクーポンを配信します！是非お使いください！\n#{response['url']}"
      }
      client.push_message(user, message)
      count = count - 1
    end
    flash[:notice] = "#{users.count}件クーポンを配信しました。"
    redirect_to controller: :welcome

  end
end
