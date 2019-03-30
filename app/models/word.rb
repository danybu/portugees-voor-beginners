class Word < ApplicationRecord
  strip_attributes
  validates :port_word, presence: true
  validates :nl_translation, presence: true

  def self lookup_port_word(word)
    return Word.where("port_word ILIKE :query", query: word).order(port_word)
  end

end
