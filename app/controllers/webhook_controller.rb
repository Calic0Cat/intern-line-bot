require 'line/bot'

class WebhookController < ApplicationController
  protect_from_forgery except: [:callback] # CSRF対策無効化

  include LineConcern

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head 470
    end

    events = client.parse_events_from(body)
    events.each { |event|
      case event
      when Line::Bot::Event::Follow
        user = User.find_or_create_by!(line_id: event['source']['userId'])
        message = {
          type: 'text',
          text: "友だち追加ありがとうございます!\nPlanet CafeのLINE公式アカウントで、お気に入りのコーヒーとフードを見つけてみませんか。"
        }       
        if user.enable
          request_code = SecureRandom.urlsafe_base64(30)
          response = GajoenApi.create_tickets(brand_id: 145, item_id: 56509, request_code: request_code)
          Coupon.create!(user_id: user.id, item_id: response['item_id'], brand_id: response['brand_id'], coupon_url: response['url'], request_code: request_code)
          message[:text] = message[:text] + "\n感謝の気持ちを込めてクーポンを送ります!\n是非お使いください!#{response['url']}"
        else
          user.update!({enable: true})
        end
        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::Unfollow
        user = User.find_by!(line_id: event['source']['userId'])
        user.update!({enable: false})

      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: event.message['text']
          }
          client.reply_message(event['replyToken'], message)
        when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
          response = client.get_message_content(event.message['id'])
          tf = Tempfile.open("content")
          tf.write(response.body)
        end
      end
    }
    head :ok
  end
end
