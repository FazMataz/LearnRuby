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
      square = Square.new("a", 3, "King")
      expect(square.piece.class.name).to eql("King")
    end
  end
end

RSpec.describe "Piece" do
  describe "#initialize" do
    it "Can be either black or white" do
      king = King.new(Square.new("a", 1), "black")
      expect(king.color).to eql("black")
    end
  end
end