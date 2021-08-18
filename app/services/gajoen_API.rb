require 'net/https'
require 'uri'
require 'securerandom'

module GAJOEN_API
  module GetItem
    class Request
      attr_accessor :query

      def initialize(brand_id)
        request_code = SecureRandom.base64(50)
        @url = ENV['GAJOEN_URI']+"/brands/#{brand_id}/tickets/#{request_code}"
      end

      def request
        uri = URI.parse(@url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        req = Net::HTTP::Get.new(uri.request_uri)
        req['Authorization'] = "Bearer #{ENV['GAJOEN_HEADER']}"
        req['X-Giftee'] = 1
        res = http.request(req)
        JSON.parse(res.body)
      end

    end
  end
end
