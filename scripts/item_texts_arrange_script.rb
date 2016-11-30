require 'bundler'
Bundler.require

require './models/item'
require './models/error'
require 'erb'

config = YAML.load(ERB.new(File.read('database/config.yml')).result)
ActiveRecord::Base.establish_connection(config['db']['development'])

def can_include?(line)
  !line.include?("記号") || !line.include?("地域") || !line.include?("助動詞") || !line.include?("助詞")
end

Item.find_each(batch_size: 25) do |item|
  description = item.description
  non_tagged = description.gsub(/<.+?>/, '')
  nm = Natto::MeCab.new(output_format_type: :wakati)
  wakati = nm.parse(non_tagged)
  begin
    ActiveRecord::Base.transaction do
      item.non_tagged_description = wakati
      item.save!
      puts "success to update non tagged description of auction_id: #{item.auction_id}"
    end
  rescue ex
    puts "failed!!! auction_id: #{item.auction_id}"
    puts ex.message
  end
end
