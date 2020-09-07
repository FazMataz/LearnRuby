require "set"
require "yaml"
ALPHABET = "abcdefgh"
ALPHABETPADDED = "zzzzzzzzzzzzabcdefghzzzzzzzzzzz"

class Board
  attr_reader :grid
  def initialize
    @grid = Hash.new(nil)
    @whites = []
    @blacks = []
    (1..8).each do |v|
      ALPHABET.each_char do |c|
        @grid[[c, v]] = Square.new(c, v, nil, nil, self)
      end
    end
  end

  def save
    File.open("save.yml", "w") {|file| file.write(YAML.dump ({
      :grid => @grid,
    }))}
  end

  def load
    data = YAML.load File.open("save.yml", "r")
    @grid = data[:grid]
  end

  def setpiece(c, v, piece, color)
    newpiece = @grid[[c, v]].genpiece(piece, color)
    if color == "black"
      @blacks << newpiece
    elsif color == "white"
      @whites << newpiece
    end
  end

  def getall(color)
    if color != "white" && color != "black"
      raise StandardError.new "Invalid color."
    elsif color == "white"
      return @whites
    elsif color == "black"
      return @blacks
    end
  end

  def move(c1, v1, c2, v2)
    piece = @grid[[c1, v1]].piece
    if !@grid[[c2, v2]].piece.nil?
      if @grid[[c2, v2]].piece.color == "black"
        @blacks.delete(@grid[[c2, v2]].piece)
      elsif @grid[[c2, v2]].piece.color == "white"
        @white.delete(@grid[[c2, v2]].piece)
      end
    end
    @grid[[c1, v1]].clear
    @grid[[c2, v2]].setpiece(piece)
  end

  def possible_moves(c, v)
    piece = @grid[[c, v]].piece
    piece.possible_moves
  end

  def fillboard
    setpiece("a", 1, "Rook", "white")
    setpiece("b", 1, "Knight", "white")
    setpiece("c", 1, "Bishop", "white")
    setpiece("d", 1, "Queen", "white")
    setpiece("e", 1, "King", "white")
    setpiece("f", 1, "Bishop", "white")
    setpiece("g", 1, "Knight", "white")
    setpiece("h", 1, "Rook", "white")
    setpiece("a", 8, "Rook", "black")
    setpiece("b", 8, "Knight", "black")
    setpiece("c", 8, "Bishop", "black")
    setpiece("d", 8, "Queen", "black")
    setpiece("e", 8, "King", "black")
    setpiece("f", 8, "Bishop", "black")
    setpiece("g", 8, "Knight", "black")
    setpiece("h", 8, "Rook", "black")
    setpiece("a", 2, "Pawn", "white")
    setpiece("b", 2, "Pawn", "white")
    setpiece("c", 2, "Pawn", "white")
    setpiece("d", 2, "Pawn", "white")
    setpiece("e", 2, "Pawn", "white")
    setpiece("f", 2, "Pawn", "white")
    setpiece("g", 2, "Pawn", "white")
    setpiece("h", 2, "Pawn", "white")
    setpiece("a", 7, "Pawn", "black")
    setpiece("b", 7, "Pawn", "black")
    setpiece("c", 7, "Pawn", "black")
    setpiece("d", 7, "Pawn", "black")
    setpiece("e", 7, "Pawn", "black")
    setpiece("f", 7, "Pawn", "black")
    setpiece("g", 7, "Pawn", "black")
    setpiece("h", 7, "Pawn", "black")
  end

  def pretty_print
    printer = ""
    (1..8).each do |num|
      letterline = ""
      ALPHABET.each_char do |letter|
        letterline += @grid[[letter, num]].piece.nil? ? "|   |" : "| #{@grid[[letter, num]].piece} |"
      end
      printer += (letterline + "\n")
    end
    printer
  end

  def check?(c, v, colour)
    v = v.to_i
    if colour != "black" && colour != "white"
      raise ValueError.new "Invalid Colour"
    elsif colour == "black"
      getall("white").each do |piece|
        if piece.possible_moves.include?([c, v])
          return true
        end
      end
    elsif colour == "white"
      getall("black").each do |piece|
        if piece.possible_moves.include?([c, v])
          return true
        end
      end
    end
    return false
  end

  def checkmate?(c, v, colour)
    v = v.to_i
    if colour != "black" && colour != "white"
      raise ValueError.new "Invalid Colour"
    end
    if !check?(c, v, colour)
      false
    else
      self.grid[[c, v]].piece.possible_moves.all? {|move| check?(move[0], move[1], colour) == true}
    end
  end
end

class Square
  attr_reader :board, :piece, :loc
  def initialize(c, v, piece = nil, color = nil, board = nil)
    @loc = [c, v]
    @board = board
    if piece.nil?
      return
    end

    genpiece(piece, color)
  end

  def genpiece(piece, color)
    case piece
    when "King"
      @piece = King.new(self, color)
    when "Queen"
      @piece = Queen.new(self, color)
    when "Rook"
      @piece = Rook.new(self, color)
    when "Bishop"
      @piece = Bishop.new(self, color)
    when "Knight"
      @piece = Knight.new(self, color)
    when "Pawn"
      @piece = Pawn.new(self, color)
    end
    @piece
  end

  def clear
    @piece = nil
  end

  def setpiece(piece)
    piece.change_location(self)
    @piece = piece
  end

end

class Piece
  attr_reader :color, :square
  def initialize(square, color)
    @square = square
    @possible_moves = Set[]
    @distance_lim = true
    case color.downcase
    when "black" || "b"
      @color = "black"
    when "white" || "w"
      @color = "white"
    else
      raise StandardError.new "Invalid color."
    end
  end

  def to_s
    @symbol
  end

  def change_location(square)
    @square = square
  end

  def possible_moves
    if @distance_lim
      moves = @possible_moves.filter_map do |move|
        move_converted = [ALPHABETPADDED[move[0] + ALPHABETPADDED.index(@square.loc[0])], move[1] + @square.loc[1]]
        if ALPHABET.include?(move_converted[0]) && move_converted[1] >= 1 && move_converted[1] <= 8
          if @square.board.grid[move_converted].piece.nil?
            move_converted
          elsif @square.board.grid[move_converted].piece.color != @color
            move_converted
          else
            nil
          end
        end
      end
      if self.class.name == "Pawn"
        only_take_move = Set[[1, 1], [-1, 1]]
        moves += only_take_move.filter_map do |take_move|
          converted_take_move = [ALPHABETPADDED[take_move[0] + ALPHABETPADDED.index(@square.loc[0])], take_move[1] + @square.loc[1]]
          if ALPHABET.include?(converted_take_move[0]) && converted_take_move[1] >= 1 && converted_take_move[1] <= 8
            if !@square.board.grid[converted_take_move].piece.nil? && @square.board.grid[converted_take_move].piece.color != @color
              converted_take_move
            else
              nil
            end
          end
        end
      end
    else
      moves = @possible_moves.map do |move|
        stop = false
        (1..8).filter_map do |number|
          if stop
            nil
          end
          scaledmove = move.map{|submove| submove * number}
          newmove = [ALPHABETPADDED[scaledmove[0] + ALPHABETPADDED.index(@square.loc[0])], scaledmove[1] + @square.loc[1]]
          if @square.board.grid.key?(newmove) && !@square.board.grid[newmove].piece.nil?
            if @square.board.grid[newmove].piece.color == @color
              stop = true
              nil
            else
              stop = true
              newmove
            end
          else
            newmove if ALPHABET.include?(newmove[0]) && newmove[1] >= 1 && newmove[1] <= 8 && !stop
          end
        end
      end
      moves = moves.flatten(1).compact
    end
    moves.to_set
  end
end

class King < Piece
  def initialize(square, color)
    super(square, color)
    @possible_moves = Set[[1, 0], [0, 1], [1, 1], [-1, 0], [0, -1], [-1, -1], [-1, 1], [1, -1]]
    @distance_lim = true
    case color.downcase
    when "white" || "w"
      @symbol = "♔"
    when "black" || "b"
      @symbol = "♚"
    end
  end
end

class Queen < Piece
  def initialize(square, color)
    super(square, color)
    @possible_moves = Set[[1, 0], [0, 1], [1, 1], [-1, 0], [0, -1], [-1, -1], [-1, 1], [1, -1]]
    @distance_lim = false
    case color.downcase
    when "white" || "w"
      @symbol = "♕"
    when "black" || "b"
      @symbol = "♛"
    end
  end
end

class Rook < Piece
  def initialize(square, color)
    super(square, color)
    @possible_moves = Set[[0, 1], [1, 0], [0, -1], [-1, 0]]
    @distance_lim = false
    case color.downcase
    when "white" || "w"
      @symbol = "♖"
    when "black" || "b"
      @symbol = "♜"
    end
  end
end

class Knight < Piece
  def initialize(square, color)
    super(square, color)
    @possible_moves = Set[[2, 1], [1, 2], [2, -1], [-1, 2], [-2, -1], [-1, -2], [-2, 1], [1, -2]]
    @distance_lim = true
    case color.downcase
    when "white" || "w"
      @symbol = "♘"
    when "black" || "b"
      @symbol = "♞"
    end
  end
end

class Bishop < Piece
  def initialize(square, color)
    super(square, color)
    @possible_moves = Set[[1, 1], [-1, 1], [1, -1], [-1, -1]]
    @distance_lim = false
    case color.downcase
    when "white" || "w"
      @symbol = "♗"
    when "black" || "b"
      @symbol = "♝"
    end
  end
end

class Pawn < Piece
  def initialize(square, color)
    super(square, color)
    @possible_moves = Set[[0, 1]]
    @distance_lim = true
    @first_move = true
    case color.downcase
    when "white" || "w"
      @symbol = "♙"
    when "black" || "b"
      @symbol = "♟︎"
    end
  end

  def possible_moves
    if @first_move == true
      @possible_moves.add([0, 2])
      @first_move = false
    else
      @possible_moves.delete([0, 2])
    end
    super
  end
end