class Board
  attr_reader :grid
  def initialize
    @grid = Hash.new(nil)
    (0..8).each do |v|
      "abcdefgh".each_char do |c|
        @grid[[c, v]] = Square.new(c, v)
      end
    end
  end
end

class Square
  attr_reader :piece
  def initialize(c, v, piece = nil)
    @loc = [c, v]
    @piece = piece
    case piece
    when "King"
      @piece = King.new(c, v)
    when "Queen"
      @piece = Queen.new(c, v)
    when "Rook"
      @piece = Rook.new(c, v)
    when "Bishop"
      @piece = Bishop.new(c, v)
    when "Knight"
      @piece = Knight.new(c, v)
    when "Pawn"
      @piece = Pawn.new(c, v)
    end
  end
end

class Piece
  def initialize(c, v)
    @loc = [c, v]
  end
end

class King
  def initialize(c, v)
    super()
  end
end