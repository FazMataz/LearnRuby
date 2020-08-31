require './lib/chess.rb'

RSpec.describe "Board" do
  describe "#initialize" do
    it "Generates an 8x8 board" do
      board = Board.new
      expect(board.grid[["z", 15]].nil?).to eql(true)
      expect(board.grid[["a", 8]].nil?).to eql(false)
    end

    it "Grid contains squares" do
      board = Board.new
      expect(board.grid[["a", 5]].class.name).to eql("Square")
    end
  end
  describe "#setpiece" do
    it "Generates a piece in a square" do
      board = Board.new
      board.setpiece("a", 1, "King", "black")
      expect(board.grid[["a", 1]].piece.class.name).to eql("King")
    end
  end
  describe "#move" do
    it "Moves a piece from one square to another" do
      board = Board.new
      board.setpiece("a", 1, "King", "black")
      board.move("a", 1, "b", 2)
      expect(board.grid[["a", 1]].piece).to eql(nil)
      expect(board.grid[["b", 2]].piece.class.name).to eql("King")
    end
  end
end

RSpec.describe "Square" do
  describe "@piece" do
    it "Contains a piece object" do
      square = Square.new("a", 3, "King", "black")
      expect(square.piece.class.name).to eql("King")
    end
  end
end

RSpec.describe "Piece" do
  describe "#initialize" do
    it "Can be either black or white" do
      piece = King.new(Square.new("a", 1), "black")
      expect(piece.color).to eql("black")
      piece = Queen.new(Square.new("a", 1), "black")
      expect(piece.color).to eql("black")
      piece = Rook.new(Square.new("a", 1), "black")
      expect(piece.color).to eql("black")
      piece = Knight.new(Square.new("a", 1), "black")
      expect(piece.color).to eql("black")
      piece = Bishop.new(Square.new("a", 1), "black")
      expect(piece.color).to eql("black")
      piece = Pawn.new(Square.new("a", 1), "black")
      expect(piece.color).to eql("black")
    end
    it "Each piece has a symbol, that also depends on color" do
      piece = King.new(Square.new("a", 1), "black")
      expect(piece.to_s).to eql("♚")
      piece = King.new(Square.new("a", 1), "white")
      expect(piece.to_s).to eql("♔")
    end
  end
  describe "#possible_moves" do
    it "Possible moves does not include boxes occupied by same color" do
      board = Board.new
      board.setpiece("a", 1, "Rook", "black")
      board.setpiece("a", 2, "Pawn", "black")
      board.setpiece("b", 1, "Pawn", "black")
      expect(board.possible_moves("a", 1)).to eql(Set[])
    end
    it "Possible moves does not include boxes occupied by the same color(2)" do
      board = Board.new
      board.setpiece("a", 1, "Queen", "black")
      board.setpiece("a", 3, "Pawn", "black")
      board.setpiece("c", 1, "Pawn", "black")
      board.setpiece("c", 3, "Pawn", "black")
      expect(board.possible_moves("a", 1)).to eql(Set[["a", 2], ["b", 1], ["b", 2]])
    end
    it "Possible moves includes boxes occupied by opposite color, but not beyond" do
      board = Board.new
      board.setpiece("a", 1, "Rook", "black")
      board.setpiece("a", 2, "Pawn", "white")
      board.setpiece("b", 1, "Pawn", "white")
      expect(board.possible_moves("a", 1)).to eql(Set[["a", 2], ["b", 1]])
    end
    it "Possible moves includes boxes occupied by opposite color, but not beyond(2)" do
      board = Board.new
      board.setpiece("a", 1, "Queen", "black")
      board.setpiece("a", 2, "Pawn", "white")
      board.setpiece("b", 1, "Pawn", "white")
      board.setpiece("b", 2, "Pawn", "white")
      expect(board.possible_moves("a", 1)).to eql(Set[["a", 2], ["b", 1], ["b", 2]])
    end
  end
end

RSpec.describe "King" do
  describe "#possible_moves" do
    it "Will only move 1 square in any direction" do
      board = Board.new
      board.setpiece("a", 1, "King", "black")
      expect(board.possible_moves("a", 1)).to eql(Set[["a", 2], ["b", 1], ["b", 2]])
    end
  end
end

RSpec.describe "Queen" do
  describe "#possible_moves" do
    it "Will move in all directions" do
      board = Board.new
      board.setpiece("a", 1, "Queen", "black")
      expect(board.possible_moves("a", 1)).to eql(Set[["a", 2], ["a", 3], ["a", 4], ["a", 5], ["a", 6], ["a", 7], ["a", 8], ["b", 1], ["c", 1], ["d", 1], ["e", 1], ["f", 1], ["g", 1], ["h", 1], ["b", 2], ["c", 3], ["d", 4], ["e", 5], ["f", 6], ["g", 7], ["h", 8]])
    end
  end
end

RSpec.describe "Pawn" do
  describe "#possible_moves" do
    it "Will only move 1 step forward" do
      board = Board.new
      board.setpiece("a", 1, "Pawn", "black")
      expect(board.possible_moves("a", 1)).to eql(Set[["a", 2]])
    end
  end
end

RSpec.describe "Rook" do
  describe "#possible_moves" do
    it "Will only move horizontally and vertically" do
      board = Board.new
      board.setpiece("a", 1, "Rook", "black")
      expect(board.possible_moves("a", 1)).to eql(Set[["a", 2], ["a", 3], ["a", 4], ["a", 5], ["a", 6], ["a", 7], ["a", 8], ["b", 1], ["c", 1], ["d", 1], ["e", 1], ["f", 1], ["g", 1], ["h", 1]])
    end
  end
end

RSpec.describe "Knight" do
  describe "#possible_moves" do
    it "Will only move in Knight Pattern" do
      board = Board.new
      board.setpiece("a", 1, "Knight", "black")
      expect(board.possible_moves("a", 1)).to eql(Set[["b", 3], ["c", 2]])
    end
  end
end

RSpec.describe "Bishop" do
  describe "#possible_moves" do
    it "Only diagonally" do
      board = Board.new
      board.setpiece("a", 1, "Bishop", "black")
      expect(board.possible_moves("a", 1)).to eql(Set[["b", 2], ["c", 3], ["d", 4], ["e", 5], ["f", 6], ["g", 7], ["h", 8]])
    end
  end
end