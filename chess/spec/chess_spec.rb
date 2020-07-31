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