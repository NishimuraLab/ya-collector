require 'bundler'
Bundler.require

require './models/item'
require './models/processed_text'
require './models/error'
require 'erb'

config = YAML.load(ERB.new(File.read('database/config.yml')).result)
ActiveRecord::Base.establish_connection(config['db']['development'])

# deprecated
def not_include?(line)
  line.include?("記号") || line.include?("地域") || line.include?("助動詞") || line.include?("助詞") || line.include?("EOS")
end

def noun?(line)
  line.include?("名詞")
end

def integer?(line)
  line.include?("数")
end

def should_include?(line)
  noun?(line) || integer?(line)
end

# deprecated
def wakati_black(text)
  nm = Natto::MeCab.new(dicdir: '/usr/local/lib/mecab/dic/mecab-ipadic-neologd/')
  parsed = nm.parse(trim_tag(text))

  wakatied_text = ''
  parsed.split(/\n/).each do |line|
    next if not_include?(line)
    wakatied_text += line.split(/\t/)[0] + ' '
  end
  wakatied_text
end

def wakati_white(text)
  nm = Natto::MeCab.new(dicdir: '/usr/local/lib/mecab/dic/mecab-ipadic-neologd/')
  parsed = nm.parse(trim_tag(text))

  white_wakatied_text = ''
  parsed.split(/\n/).each do |line|
    next if !should_include?(line)
    white_wakatied_text += line.split(/\t/)[0] + ' '
  end
  white_wakatied_text
end

def trim_tag(text)
  text.gsub(/<.+?>/, '').gsub(/\&nbsp/, '')
end

Item.find_each(batch_size: 25) do |item|
  wakati_white_description = wakati_white(item.description)
  wakati_white_item = wakati_white(item.title)

  wakati_black_description = wakati_black(item.description)
  wakati_black_title = wakati_black(item.title)

  begin
    ActiveRecord::Base.transaction do
      item.processed_texts.create!(
        process_type: 'noun_only',
        description: wakati_white_description,
        title: wakati_white_description
      )
      item.processed_texts.create!(
        process_type: 'symbol_region_postposition_averb_eos_excluded',
        description: wakati_black_description,
        title: wakati_black_title
      )
      puts "success to wakati and insert. auction_id: #{item.auction_id}"
    end
  rescue => ex
    puts "failed!!! auction_id: #{item.auction_id}"
    puts ex.message
    puts ex.backtrace
  end
end
puts "end of script"
