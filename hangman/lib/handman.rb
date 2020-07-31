# frozen-string-literals: true
require "yaml"

# Container for Game Processes
class Game
  private

  def getwords
    file = File.open("5desk.txt")
    words = file.readlines.map(&:chomp).select { |word| word.length >= 5 && word.length <= 12 }
    file.close
    words
  end

  private

  def pick_random_word(wordlist)
    wordlist[rand(wordlist.length)]
  end

  def initialize
    @word = pick_random_word(getwords)
    @guesses = []
    @gameover = false
    while status == false && @gameover != true
      p "Enter a guess! (write load or save to load or save)"
      input(gets.chomp)
    end
  end

  private

  def word_bar
    word_bar = @word.split('').reduce("") do |wb, letter|
      if @guesses.include?(letter.downcase)
        wb + letter
      else
        wb + "_"
      end
    end
    word_bar.split("").join(" ")
  end

  public

  def input(string)
    if string.downcase == "save"
      serialize
    elsif string.downcase == "load"
      deserialize
    elsif string.downcase == "exit"
      @gameover = true
    else guess(string)
    end
  end

  private

  def serialize
    File.open("save.yml", "w") { |file| file.write(YAML.dump ({
      :word => @word,
      :guesses => @guesses,
    }))}
  end

  private

  def deserialize
    data = YAML.load File.open("save.yml", "r")
    @guesses = data[:guesses]
    @word = data[:word]
  end

  private

  def guess(letter)
    if !letter.match?(/[a-zA-Z]/) || letter.length > 1
      print "#{letter} is an invalid guess. Try another."
      return false
    end
    letter = letter.downcase
    if @word.include?(letter) && !@guesses.include?(letter)
      p "#{letter} is correct! Well Done!"
      @guesses << letter
      true
    elsif @guesses.include?(letter)
      p "You've already guessed #{letter}"
      true
    elsif !@word.include?(letter)
      p "#{letter} was incorrect, try again!"
      @guesses << letter
      false
    end
  end

  public

  def status
    p "Progress: #{word_bar}, Guesses: #{@guesses.length}"
    p @guesses.join(", ").chomp(", ")
    if @word.downcase == word_bar.split(" ").join().downcase
      p "You won!!"
      true
    else false
    end
  end
end

new_game = Game.new
