class WordsController < ApplicationController
  def index
  end

  def lookup
    @port_word = params[:lookup][:port_word]
  end
end
