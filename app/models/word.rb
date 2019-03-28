class Word < ApplicationRecord
  validates :port_word, presence: true, uniqueness: true
  validates :nl_translation, presence: true
end
