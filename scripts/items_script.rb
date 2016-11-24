require 'bundler'
Bundler.require

require './yahoo_api_connector'
require './models/item'
require './models/category'
require './models/image'
require './models/error'
require 'erb'

# TODO: jsonパースしたやつのkeyのdowncaseしたいなあ

def params_of_item(item)
  easy_payment = item.Payment.EasyPayment
  {
    auction_id: item.AuctionID,
    category_id: item.CategoryID,
    category_path: item.CategoryPath,
    title: item.Title,
    seller_id: item.Seller.Id,
    seller_rating_point: item.Seller.Rating.Point,
    seller_rating_is_suspended: item.Seller.Rating.IsSuspended,
    seller_rating_is_deleted: item.Seller.Rating.IsDeleted,
    seller_item_list_url: item.Seller.ItemListUrl,
    seller_rating_url: item.Seller.RatingURL,
    auction_item_url: item.AuctionItemUrl,
    init_price: item.Initprice,
    current_price: item.Price,
    quantity: item.Quantity,
    available_quantity: item.AvailableQuantity,
    current_bids: item.Bids,
    highest_bidder_id: item.HighestBidders&.Bidder ? item.HighestBidders&.Bidder[0]&.Id : nil,
    highest_bidder_rating_point: item.HighestBidders&.Bidder ? item.HighestBidders&.Bidder&.Rating&.Point : nil,
    highest_bidder_rating_is_suspended: item.HighestBidders&.Bidder ? item.HighestBidders.Bidder[0]&.Rating&.IsSuspended : nil,
    highest_bidder_rating_is_deleted: item.HighestBidders&.Bidder ? item.HighestBidders.Bidder[0]&.Rating&.IsDeleted : nil,
    highest_bidder_item_list_url: item.HighestBidders&.Bidder ? item.HighestBidders.Bidder[0]&.ItemListURL : nil,
    highest_bidder_rating_url: item.HighestBidders&.Bidder ? item.HighestBidders.Bidder[0]&.RatingURL : nil,
    highest_bidders_is_more: item.HighestBidders&.IsMore,
    y_point: item.YPoint,
    item_status_condition: item.ItemStatus.Condition,
    item_status_comment: item.ItemStatus.Comment,
    item_returnable_allowed: item.ItemReturnable&.Allowed,
    item_returnable_comment: item.ItemReturnable&.Comment,
    start_time: item.StartTime,
    end_time: item.EndTime,
    bidor_buy: item.Bidorbuy,
    tax_rate: item.TaxRate,
    taxin_price: item.TaxinPrice,
    taxin_bidor_buy: item.TaxBidorbuy,
    reserved_price: item.Reserved,
    is_bid_credit_restrictions: item.IsBidCreditRestrictions,
    is_bidder_restriction: item.IsBidderRestrictions,
    is_bidder_ratio_restriction: item.IsBidderRatioRestrictions,
    is_early_closing: item.IsEarlyClosing,
    is_automatic_extension: item.IsAutomaticExtension,
    is_offer: item.IsOffer,
    is_charity: item.IsCharity,
    description: item.Description,
    easy_payment_safe_keeping_payment: easy_payment ? easy_payment.SafeKeepingPayment : nil,
    easy_payment_is_credit_card: easy_payment ? easy_payment.IsCreditCard : nil,
    easy_payment_is_net_bank: easy_payment ? easy_payment.IsNetBank : nil,
    payment_bank_method: item.Payment.Bank.class == String ? item.Payment.Bank : item.Payment.Bank&.Method,
    payment_cash_registration: item.Payment.CashRegistration,
    payment_postal_transfer: item.Payment.PostalTransfer,
    payment_postal_order: item.Payment.PostalOrder,
    payment_cash_on_delivery: item.Payment.CashOnDelivery,
    payment_credit_card: item.Payment.CreditCard,
    payment_loan: item.Payment.Loan,
    payment_other_method: item.Payment.Other ? item.Payment.Other.Method : nil,
    charge_for_shipping: item.ChargeForShipping,
    location: item.Location,
    is_world_wide: item.IsWorldWide,
    ship_time: item.ShipTime,
    baggage_info_size: item.BaggageInfo.Size,
    baggage_info_weight: item.BaggageInfo.Weight,
    is_adult: item.IsAdult,
    charity_option_propotion: item.CharityOption,
    answered_q_and_a_num: item.AnsweredQAndANum,
    status: item.Status
  }
end

def params_of_image(image, item_id)
  {
    item_id: item_id,
    image_url: image
  }
end

def generate_error_message(ex)
  ex.message + "\n" + ex.backtrace.join("\n")
end

config = YAML.load(ERB.new(File.read('database/config.yml')).result)
ActiveRecord::Base.establish_connection(config['db']['development'])

yahoo = YahooApiConnector.new(ENV['YAHOO_API_KEY'])
# puts Hashie::Mash.new(yahoo.item_by('e165233993')).ResultSet.Result
# puts params_of_item(Hashie::Mash.new(yahoo.item_by('e165233993')).ResultSet.Result)
# exit
# puts Hashie::Mash.new(yahoo.category_leaf_by('23632')).ResultSet.attributes.totalResultsAvailable
# puts Hashie::Mash.new(yahoo.category_leaf_by('23336', 16)).ResultSet.Result.Item.map{|item| item[:AuctionID]}
Category.find_each(batch_size: 25) do |category|
  # category_idが0だとBad Requestのエラーが返ってくるので飛ばす
  next if category.category_id == 0

  begin
    begin
      result_set = Hashie::Mash.new(yahoo.category_leaf_by(category.category_id)).ResultSet
      # この後のtimesメソッドは0から始まるのでfloorにして、引数に渡す時に+1する
      total_page_cnt = result_set.attributes.totalResultsAvailable.to_i
    rescue => ex
      puts "error!! \n category_id: #{category.category_id}"
      Error.create!({
        object_id: category.category_id,
        object_type: 'category',
        stack_trace: generate_error_message(ex)
      })
    end

    total_page_cnt.times do |page|
      puts "category_id: #{category.category_id}, page: #{page + 1}"
      begin
        # timesは0から始まる
        result_set = Hashie::Mash.new(yahoo.category_leaf_by(category.category_id, page + 1)).ResultSet
        result = result_set.Result
        item_auction_ids = result.Item.map{|item| item[:AuctionID]}
      rescue => ex
        puts "error!! \n category_id: #{category.category_id}"
        puts result_set
        Error.create!({
          object_id: category.category_id,
          object_type: 'category',
          stack_trace: generate_error_message(ex)
        })
      end

      item_auction_ids.each do |auction_id|
        if Item.find_by(auction_id: auction_id)
          puts "duplicate! \n auction_id: #{auction_id}"
          next
        end

        begin
          item_hash = Hashie::Mash.new(yahoo.item_by(auction_id)).ResultSet.Result
        rescue => ex
          puts "error!! \n auction_id: #{auction_id}"
          Error.create!({
            object_id: auction_id,
            object_type: 'item',
            stack_trace: generate_error_message(ex)
          })
        end

        ActiveRecord::Base.transaction do
          begin
            object_type = 'item2'
            new_item = Item.create!(params_of_item(item_hash))

            object_type = 'image'
            unless item_hash.Img&.class == String
              Image.create!(params_of_image(item_hash.Img.Image1, new_item.id)) if item_hash.Img.Image1
              Image.create!(params_of_image(item_hash.Img.Image2, new_item.id)) if item_hash.Img.Image2
              Image.create!(params_of_image(item_hash.Img.Image3, new_item.id)) if item_hash.Img.Image3
              Image.create!(params_of_image(item_hash.Img.Image4, new_item.id)) if item_hash.Img.Image4
              Image.create!(params_of_image(item_hash.Img.Image5, new_item.id)) if item_hash.Img.Image5
              Image.create!(params_of_image(item_hash.Img.Image6, new_item.id)) if item_hash.Img.Image6
              Image.create!(params_of_image(item_hash.Img.Image7, new_item.id)) if item_hash.Img.Image7
              Image.create!(params_of_image(item_hash.Img.Image8, new_item.id)) if item_hash.Img.Image8
              Image.create!(params_of_image(item_hash.Img.Image9, new_item.id)) if item_hash.Img.Image9
              Image.create!(params_of_image(item_hash.Img.Image10, new_item.id)) if item_hash.Img.Image10
              puts "success to insert item and image !! \n category_id: #{category.category_id} \n  auction_id: #{auction_id}"
            end
          rescue => ex
            puts "error2!! \n auction_id: #{auction_id}"
            Error.create!({
              object_id: auction_id,
              object_type: object_type,
              stack_trace: generate_error_message(ex)
            })
          end
        end
      end
    end
  rescue => ex
    Error.create!({
      object_id: category.category_id,
      object_type: 'category',
      stack_trace: generate_error_message(ex)
    })
    puts "Error! will retry \n category_id: #{category.category_id}"
    retry
  end
end

puts "End of script\n"
