class Word < ApplicationRecord
  strip_attributes
  validates :port_word, presence: true
  validates :nl_translation, presence: true
  include PgSearch
  pg_search_scope :search_by_port_word,
  against: [:port_word],
  using: {
    tsearch: { dictionary: "portuguese", prefix: false }
  }
  pg_search_scope :search_by_nl_word,
  against: [:nl_translation],
  using: {
    tsearch: { dictionary: "dutch", prefix: false }
  }

  def self.lookup_word(word)
    # portuguese to dutch
    exact_words = Word.where("port_word ILIKE :query", query: word)
    guessed_words = (Word.search_by_port_word(word) + Word.where("port_word ILIKE :query", query: "%" + word + "%")).uniq.first(15)
    guessed_words -= exact_words
    # todo conjugations
    # dutch to portuguese
    nl_words = (Word.search_by_nl_word(word) + Word.where("nl_translation ILIKE :query", query: "%" + word + "%")).uniq.first(15)
    return { exact: exact_words, guessed: guessed_words, nl: nl_words }
  end

  def self.lookup_word_to_html(word)
    word_lines = lookup_word(word)
    return "<p>geen resultaten gevonden</p>" if word_lines.size.zero?

    res_html = ''
    if !word_lines[:exact].empty?
      res_html += '<h3 class="dictionary-h3">gevonden vertaling:</h3>'
      res_html += '<table class="dictionary">'
      word_lines[:exact].each do |exact_line|
        res_html += "<tr>#{word_line_to_html(exact_line)}</tr>"
      end
      res_html += "</table>"
    end
    if !word_lines[:guessed].empty?
      res_html += '<table class="dictionary">'
      res_html += '<h3 class="dictionary-h3">relevante woorden:</h3>'
      word_lines[:guessed].each do |guessed_line|
        res_html += "<tr>#{word_line_to_html(guessed_line)}</tr>"
      end
      res_html += "</table>"
    end
    if !word_lines[:nl].empty?
      res_html += '<h3 class="dictionary-h3">nederlands --> portugees</h3>'
      res_html += '<table class="dictionary">'
      word_lines[:nl].each do |exact_line|
        res_html += "<tr>#{word_line_to_html(exact_line)}</tr>"
      end
      res_html += "</table>"
    end
    return res_html
  end

  private

  def self.word_line_to_html(word_line)
    extra_info = word_line[:port_word_fem].nil? ? '' : "<span class='feminine dictionary'>vr.: #{word_line[:port_word_fem]}</span>"
    extra_info += word_line[:port_word_plural].nil? ? '' : ", <span class='plural dictionary>' #{word_line[:port_word_plural]}</span>"
    extra_info += word_line[:example].nil? ? '' : ", vb: <span class='example dictionary'>#{word_line[:example]}</span>"
    extra_info = extra_info[2..-1] if  extra_info[0] == ','
    res = "<span class='pt dictionary'>#{article(word_line)} #{word_line[:port_word]}</span>"
    if word_line[:origin] == 'pvb'
      res = "<td><a>#{res} (les #{word_line[:level]} #{word_line[:chapter]}) </td></a>"
    else
      res = "<td>" + res + "</td> "
    end
    res += "<td><span class='nl dictionary'>#{word_line[:nl_translation]}</span></td> <td><span class='extra dictionary'>#{extra_info}</span></td>"
    return res
  end

  def self.article(word_line)
    return ''  if word_line[:genre].nil?
    return 'o ' if word_line[:genre].downcase == 'znm'
    return 'a ' if word_line[:genre].downcase == 'znv'
  end
end
