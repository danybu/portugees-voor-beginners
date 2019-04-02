class WordsController < ApplicationController
  def index
  end

  def lookup
    @port_word = params[:port_word]

  end
end
