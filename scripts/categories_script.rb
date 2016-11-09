require './yahoo_api_connector'
require './models/category'
require './yahoo_auction/category'
require 'bundler'
require 'erb'
Bundler.require

def insert_category_from_child(category_obj, yahoo_connect)
  return true if category_obj == nil
  params = params_of(category_obj)
  new_category = Category.new(params)
  puts new_category.category_id
  # ユニークバリデーションに引っかかった場合はスルー
  if !Category.find_by(category_id: new_category.category_id)
    ActiveRecord::Base.transaction do
      new_category.save!
      puts "success: #{new_category.category_name}\n"
    end
  else
    puts "category_id: #{new_category.category_id} exists on DB."
  end

  return true if category_obj.is_leaf
  category_obj.child_categories.each do |child|
    category = YahooAuction::Category::ResultSet.parse(
      yahoo_connect.categories_by(child.category_id), single: true
    ).category
    sleep 2

    result = insert_category_from_child(category, yahoo_connect)
    next if result
  end

  true
end

def params_of(category)
  {
    category_id: category.category_id,
    category_name: category.category_name,
    category_id_path: category.category_id_path,
    parent_category_id: category.parent_category_id,
    is_leaf: category.is_leaf,
    depth: category.depth,
    order: category.order,
    is_link: category.is_link,
    child_category_num: category.child_category_num
  }
end

config = YAML.load(ERB.new(File.read('database/config.yml')).result)
ActiveRecord::Base.establish_connection(config['db']['development'])
yahoo = YahooApiConnector.new(ENV['YAHOO_API_KEY'])

category_id = 0
result = YahooAuction::Category::ResultSet.parse(
  yahoo.categories_by(category_id), single: true
)
# sleepさせる
sleep 2

category = result.category
insert_category_from_child(category, yahoo)

puts "End of script\n"
