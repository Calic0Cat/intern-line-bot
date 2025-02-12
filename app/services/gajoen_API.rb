require 'net/https'
require 'uri'
require 'securerandom'

class GajoenApi
  def self.create_tickets(brand_id:, item_id:, request_code:)
    query={
      "item_id"=>item_id,
      "request_code"=>request_code
    }
    url = ENV['GAJOEN_URI']+"/brands/#{brand_id}/tickets/"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Post.new(uri.request_uri)
    req['Authorization'] = "Bearer #{ENV['GAJOEN_HEADER']}"
    req['X-Giftee'] = 1
    req.set_form_data(query)
    res = http.request(req)
    case res
    when Net::HTTPSuccess
      JSON.parse(res.body)
    else
      raise 'チケット発行に失敗しました。'
    end
  end
end
