require 'nokogiri'
require 'open-uri'

def open_file_vocabulary_kosmos
  # filepath = Rails.root.join "lib", "assets", "PVB_AlleVocab_Numbers_Manual.html"
  file = File.open('./lib/assets/original_csvs/KosmosCOMPL.html')
  return Nokogiri::XML(file)
end

def read_vocabulary_kosmos
  res_array = []
  open_file_vocabulary_kosmos.root.xpath('//tr').each do |row|
    tds = row.xpath('td')
    res_array << {
      origin: 'kosmos',
      level: 0, #0 == KOSMOS
      port_word: tds[2].text,
      port_word_fem: tds[3].text == "&nbsp;" ? nil : tds[3].text,
      port_word_plural: tds[4].text == "&nbsp;" ? nil : tds[4].text,
      nl_translation: tds[5].text,
      genre: tds[6].text == "&nbsp;" ? nil : tds[6].text.downcase
    }
  end
  return res_array
end

def test
  pvb_vocabulary = read_vocabulary_kosmos
  genres = pvb_vocabulary.map { |voc_hash| voc_hash[:genre] }.uniq
  puts genres
end


# TODO: NILWAARDES ZIJN NIET NIL IN DB!
