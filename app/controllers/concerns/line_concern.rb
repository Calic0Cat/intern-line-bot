require 'active_support'

module LineConcern
  #モジュールの中でActiveSupport::Concernモジュールをエクステンドする
  extend ActiveSupport::Concern

  #ClassMethodsモジュールの中で、インクルーダーに追加するクラスメソッドを定義する
    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      }
  end
end
