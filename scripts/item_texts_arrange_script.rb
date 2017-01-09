require 'bundler'
Bundler.require

require './models/item'
require './models/processed_text'
require './models/error'
require 'erb'

config = YAML.load(ERB.new(File.read('database/config.yml')).result)
ActiveRecord::Base.establish_connection(config['db']['development'])

def not_include?(line)
  line.include?("記号") || line.include?("地域") || line.include?("助動詞") || line.include?("助詞") || line.include?("EOS")
end

def noun?(line)
  line.include?("名詞,固有名詞") || line.include?("名詞,一般")
end

def number?(line)
  line.include?("数")
end

def should_include?(line)
  noun?(line) || number?(line)
end

def wakati_by_black_list(text)
  nm = Natto::MeCab.new(dicdir: '/usr/local/lib/mecab/dic/mecab-ipadic-neologd/')
  parsed = nm.parse(trim_tag(text))

  wakati_text = ''
  parsed.split(/\n/).each do |line|
    next if not_include?(line)
    wakati_text += line.split(/\t/)[0] + ' '
  end
  wakati_text
end

def wakati_by_white_list(text)
  nm = Natto::MeCab.new(dicdir: '/usr/local/lib/mecab/dic/mecab-ipadic-neologd/')
  parsed = nm.parse(trim_tag(text))

  wakati_text = ''
  parsed.split(/\n/).each do |line|
    next if !should_include?(line)
    wakati_text += line.split(/\t/)[0] + ' '
  end
  wakati_text
end

def trim_tag(text)
  text.gsub(/<.+?>/, '').gsub(/\&nbsp/, '')
end

Item.find_each(batch_size: 25) do |item|
  wakati_white_description = wakati_by_white_list(item.description)
  wakati_white_title = wakati_by_white_list(item.title)

  wakati_black_description = wakati_by_black_list(item.description)
  wakati_black_title = wakati_by_black_list(item.title)

  begin
    ActiveRecord::Base.transaction do
      item.processed_texts.create!(
        process_type: 'noun_number_only',
        description: wakati_white_description,
        title: wakati_white_title
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
