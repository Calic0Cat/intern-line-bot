class CouponsController < ApplicationController
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  # GET /welcome
  def create
    users = User.where(enable: true).pluck(:line_id)
    p users
    users.each do |user|
      response = GajoenApi.create_tickets(brand_id: 145, item_id: 56509)
      message = {
        type: 'text',
        text: "日頃の感謝を込めてクーポンを配信します！是非お使いください！\n#{response['url']}"
      }
      client.push_message(user, message)
    end
  end
end
