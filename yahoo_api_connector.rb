require 'bundler'
Bundler.require

class YahooApiConnector
  BASE_DOMAIN = 'http://auctions.yahooapis.jp'
  BASE_URI = '/AuctionWebService/V2'

  SEARCH_URI = "#{BASE_URI}/search"
  CATEGORY_URI = "#{BASE_URI}/categoryTree"
  ITEM_URI = "#{BASE_URI}/auctionItem"
  CATEGORY_LEAF_URI = "#{BASE_URI}/categoryLeaf"

  def initialize(app_id)
    @app_id = app_id
    @conn = Faraday.new(url: BASE_DOMAIN) do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end
  end

  def search_by(word, page_num)
    response = @conn.get(SEARCH_URI, {
      appid: @app_id,
      query: word,
      page: page_num
    })
    response.body
  end

  def categories_by(category_id = 0)
    response = @conn.get(CATEGORY_URI, { appid: @app_id, category: category_id })
    response.body
  end

  def category_leaf_by(category_id = 0, page_num = 1)
    sleep 2
    response = @conn.get(CATEGORY_LEAF_URI, {
      appid: @app_id,
      category: category_id,
      page: page_num,
      output: 'json'
    })
    parse_to_json(response.body)
  end

  def item_by(item_id)
    sleep 2
    response = @conn.get(ITEM_URI, {
      appid: @app_id,
      auctionID: item_id,
      output: 'json'
    })
    parse_to_json(response.body)
  end

  def parse_to_json(response_body)
    Oj.default_options = { symbol_keys: true }
    Oj.load(response_body.gsub(/loaded\(/, '').gsub(/@attributes/, 'attributes').chop)
  end
end
