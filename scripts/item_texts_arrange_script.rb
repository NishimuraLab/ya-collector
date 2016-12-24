require 'bundler'
Bundler.require

require './models/item'
require './models/error'
require 'erb'

config = YAML.load(ERB.new(File.read('database/config.yml')).result)
ActiveRecord::Base.establish_connection(config['db']['development'])

def not_include?(line)
  line.include?("記号") || line.include?("地域") || line.include?("助動詞") || line.include?("助詞") || line.include?("EOS")
end

def wakati(text)
  nm = Natto::MeCab.new(dicdir: '/usr/local/lib/mecab/dic/mecab-ipadic-neologd/')
  parsed = nm.parse(trim_tag(text))

  wakatied_text = ''
  parsed.split(/\n/).each do |line|
    next if not_include?(line)
    wakatied_text += line.split(/\t/)[0] + ' '
  end
  wakatied_text
end

def trim_tag(text)
  text.gsub(/<.+?>/, '').gsub(/\&nbsp/, '')
end

Item.find_each(batch_size: 25) do |item|
  wakati_description = wakati(item.description)
  wakati_title = wakati(item.title)

  begin
    ActiveRecord::Base.transaction do
      item.neologd_wakati_description = wakati_description
      item.neologd_wakati_title = wakati_title
      item.save!
      puts "success to wakati and insert. auction_id: #{item.auction_id}"
    end
  rescue => ex
    puts "failed!!! auction_id: #{item.auction_id}"
    puts ex.message
    puts ex.backtrace
  end
end
puts "end of script"
