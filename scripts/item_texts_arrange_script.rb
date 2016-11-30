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
  ActiveRecord::Base.transaction do
    item.non_tagged_description = wakati
    item.save!
  end
end
