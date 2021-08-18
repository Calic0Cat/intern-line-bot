require 'net/https'
require 'uri'
require 'securerandom'

class GajoenApi
  attr_accessor :query

  def initialize(brand_id,item_id)
    request_code = SecureRandom.urlsafe_base64(30)
    @query={
      "item_id"=>item_id,
      "request_code"=>request_code
    }
    @url = ENV['GAJOEN_URI']+"/brands/#{brand_id}/tickets/"
  end

  def request
    uri = URI.parse(@url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Post.new(uri.request_uri)
    req['Authorization'] = "Bearer #{ENV['GAJOEN_HEADER']}"
    req['X-Giftee'] = 1
    req.set_form_data(@query)
    p @query
    res = http.request(req)
    JSON.parse(res.body)
  end

end
