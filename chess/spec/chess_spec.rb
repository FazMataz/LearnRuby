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
  describe "#Move" do
    it "A piece can be moved to another square" do
      board = Board.new
      b_king = King.new(board.grid[["a", 1]], "black")
      b_king.move("a", "2")
      expect(board.grid[["a", 2]].piece.class.name).to eql("King")
    end
  end
end
