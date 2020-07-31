class Board
  attr_reader :grid
  def initialize
    @grid = Hash.new(nil)
    (0..8).each do |v|
      "abcdefgh".each_char do |c|
        @grid[[c, v]] = Square.new
      end
    end
  end
end

class Square
  def initialize(piece = nil)
    @piece = piece
    case piece
    when "King"
      @piece = King.new
    when "Queen"
      @piece = Queen.new
    when "Rook"
      @piece = Rook.new
    when "Bishop"
      @piece = Bishop.new
    when "Knight"
      @piece = Knight.new
    when "Pawn"
      @piece = Pawn.new
    end
  end
end