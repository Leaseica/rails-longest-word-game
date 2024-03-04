require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    charset = Array('A'..'Z')
    @letters =  Array.new(10) { charset.sample }
    session[:letters] = @letters
    session[:score] ||= 0
  end

  def score
    @answer = params[:answer].upcase
    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    english_words = JSON.parse(URI.open(url).read)
    @letters = session[:letters]

    if english_words["found"] && word_from_letters?(@answer, @letters)
      session[:score] += 1
      @result = "Congratulations! #{@answer} is a valid English word!"
      @score = session[:score]

    elsif !word_from_letters?(@answer, @letters)
      @result = "Sorry but #{@answer} can't be built out of #{@letters.join}"
      @score = session[:score]

    elsif
      @result = "Sorry but #{@answer} does not seem to be a valid English word."
      @score = session[:score]

    end
  end

  private

  def word_from_letters?(answer, letters)
    answer.chars.all? { |char| answer.count(char) <= letters.count(char) }
  end

end
