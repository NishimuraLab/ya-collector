require 'bundler'
Bundler.require

require './yahoo_api_connector'
require './models/item'
require './models/category'
require './models/error'
require './models/similarity'
require './models/label'
require 'erb'

config = YAML.load(ERB.new(File.read('database/config.yml')).result)
ActiveRecord::Base.establish_connection(config['db']['development'])

# Category.find_each(batch_size: 25) do |category|
category = Category.where(category_id: 2084193568).first
  auction_ids_in_category = Item.where(category_id: category.category_id).pluck(:auction_id)
  puts 'auction_ids', auction_ids_in_category
  label_ids_in_category = Label.where(auction_id: auction_ids_in_category).pluck(:id)
  puts 'label_ids', label_ids_in_category
  similarities = Similarity.where(label_id: label_ids_in_category, pair_label_id: label_ids_in_category).where('degree > ?', 0.7).order('degree DESC')
  similarity = similarities.first
  # similarities.each do |similarity|
    puts '-------------------------------'
    puts similarity.degree
    puts similarity.pair_label.item.auction_id
    puts similarity.label.item.auction_id
    puts '-------------------------------'
  # end
  # Label.where(id: [max_similarity.label_id, max_similarity.pair_label_id]).each do |label|
  #   puts label.item.auction_id
  # end
# end
