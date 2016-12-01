require 'bundler'
Bundler.require

require './models/item'
require './models/error'
require 'erb'

config = YAML.load(ERB.new(File.read('database/config.yml')).result)
ActiveRecord::Base.establish_connection(config['db']['development'])

def not_include?(line)
  line.include?("記号") || line.include?("地域") || line.include?("助動詞") || line.include?("助詞")
end

Item.where(non_tagged_description: nil).find_each(batch_size: 25) do |item|
  description = item.description
  non_tagged = description.gsub(/<.+?>/, '').gsub(/\&nbsp/, '')

  nm = Natto::MeCab.new
  mecabed = nm.parse(non_tagged)
  mecabed.split('\n').each do |line|
    next if not_include?(line)

  end
  nm_wakati = Natto::MeCab.new(output_format_type: :wakati)
  wakati = nm_wakati.parse(non_tagged)
  begin
    ActiveRecord::Base.transaction do
      item.non_tagged_description = wakati
      item.save!
      puts "success to update non tagged description of auction_id: #{item.auction_id}"
    end
  rescue => ex
    puts "failed!!! auction_id: #{item.auction_id}"
    puts ex.message
  end
end
puts "end of script"
