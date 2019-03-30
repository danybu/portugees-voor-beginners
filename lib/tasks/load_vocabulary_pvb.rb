require 'nokogiri'
require 'open-uri'

def open_file_vocabulary_pvb
  # filepath = Rails.root.join "lib", "assets", "PVB_AlleVocab_Numbers_Manual.html"
  file = File.open('./lib/assets/original_csvs/PVB_AlleVocab_Numbers_Manual.html')
  return Nokogiri::XML(file)
end

def read_vocabulary_pvb
  res_array = []
  open_file_vocabulary_pvb.root.xpath('//tr').each do |row|
    tds = row.xpath('td')
    res_array << {
      origin: 'pvb',
      level: tds[0].text,
      chapter: tds[1].text,
      port_word: tds[2].text,
      port_word_fem: tds[3].text,
      port_word_plural: tds[4].text,
      nl_translation: tds[5].text,
      genre: tds[6].text.downcase,
      example: tds[7].text
    }
  end
  return res_array
end

def test
  pvb_vocabulary = read_vocabulary_pvb
  genres = pvb_vocabulary.map { |voc_hash| voc_hash[:genre] }.uniq
  puts genres
end


