class Board
  attr_accessor :state
  attr_accessor :players
  def initialize
    @state = Array.new(7) {Array.new(6) {"O"}}
    @players = []
  end

  def show
    shows_str = ""
    (0..5).each do |i|
      shows_str += "#{@state[0][i]} #{@state[1][i]} #{@state[2][i]} #{@state[3][i]} #{@state[4][i]} #{@state[5][i]} #{@state[6][i]}\n"
    end
    shows_str
  end

  def search_subarrays(array)
    subarrays = (0..array.size-4).map{|x| array[x...x+4] }
    if subarrays.include?(["☻", "☻", "☻", "☻"])
      @players[0]
    elsif subarrays.include?(["☺", "☺", "☺", "☺"])
      @players[1]
    end
  end

  def getdiagonals(aisle, height)
    primary_index = aisle - 1
    secondary_index = height
    larray = []
    rarray = []
    loop_primary_index = primary_index
    loop_secondary_index = secondary_index
    while loop_primary_index >= 0 && loop_secondary_index >= 0
      larray << @state[loop_primary_index][loop_secondary_index]
      loop_primary_index -= 1
      loop_secondary_index -= 1
    end
    loop_primary_index = primary_index
    loop_secondary_index = secondary_index
    while loop_primary_index <= 6 && loop_secondary_index <= 5
      loop_primary_index += 1
      loop_secondary_index += 1
      larray << @state[loop_primary_index][loop_secondary_index]
    end
    loop_primary_index = primary_index
    loop_secondary_index = secondary_index
    while loop_primary_index >= 0 && loop_secondary_index <= 5
      rarray << @state[loop_primary_index][loop_secondary_index]
      loop_primary_index -= 1
      loop_secondary_index += 1
    end
    loop_primary_index = primary_index + 1
    loop_secondary_index = secondary_index - 1
    while loop_primary_index <= 6 && loop_secondary_index >= 0
      rarray << @state[loop_primary_index][loop_secondary_index]
      loop_primary_index += 1
      loop_secondary_index -= 1
    end
    [larray.compact, rarray.compact]
  end

  def winner?(aisle)
    #Detect height of aisle
    height = @state[aisle-1].index{ |play| play == "☺" || play == "☻" }
    if height.nil?
      return false
    end
    #Detects vertical win in that column
    column = @state[aisle-1]
    if search_subarrays(column)
      return search_subarrays(column)
    end
    #Detect horizontal wins
    horizontal = @state.map {|column| column[height]}
    if search_subarrays(horizontal)
      return search_subarrays(horizontal)
    end
    #Detect diagonal wins
    diagonals = getdiagonals(aisle, height)
    if search_subarrays(diagonals[0])
      return search_subarrays(diagonals[0])
    end
    if search_subarrays(diagonals[1])
      return search_subarrays(diagonals[1])
    end
    return false
  end
end

class Player
  attr_reader :symbol

  def initialize(board)
    @symbol = board.players.include?("☻") ? "☺" : "☻"
    board.players << @symbol
    @board = board
  end

  def play(aisle)
    first_play = @board.state[aisle - 1].index{ |play| play == "☺" || play == "☻" }
    if first_play.nil?
      @board.state[aisle - 1][-1] = @symbol
    elsif first_play.zero?
      puts "That column is full! You cannot make that play!"
      return false
    else
      @board.state[aisle - 1][first_play - 1] = @symbol
    end
    puts @board.show
  end
end

board = Board.new

player1 = Player.new(board)
player2 = Player.new(board)

players = [player1, player2]

lastplayaisle = 0
player_turn = 0

while board.winner?(lastplayaisle) == false
  puts "It is player #{player_turn + 1}'s turn, which aisle?'"
  lastplayaisle = gets.to_i
  players[player_turn].play(lastplayaisle)
  player_turn += 1
  player_turn = player_turn % 2
end

puts "The winner is! #{board.winner?(lastplayaisle)}"