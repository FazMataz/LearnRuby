require './lib/connect_four.rb'

describe Board do
  describe "#initialize" do
    it "Generates a board and fills it with empty slots" do
      board = Board.new
      expect(board.state).to eql(Array.new(7) {Array.new(6) {"O"}})
    end
  end

  describe "#show" do
    it "Shows the board, and its constituents" do
      board = Board.new
      expect(board.show).to eql("O O O O O O O\nO O O O O O O\nO O O O O O O\nO O O O O O O\nO O O O O O O\nO O O O O O O\n")
    end
  end

  describe "#getdiagonals" do
    it "Gets the diagonal left and upwards of the item" do
      board = Board.new
      player = Player.new(board)
      
      expect(board.getdiagonals(4, 3)).to eql([["O", "O", "O", "O", "O", "O"], ["O", "O", "O", "O", "O", "O"]])
    end
  end


  describe "#winner?" do
    it "Detects vertical win" do
      board = Board.new
      player = Player.new(board)
      4.times { player.play(4) }
      expect(board.winner?(4)).to eql("☻")
    end
    it "Detects horizontal win" do
      board = Board.new
      player = Player.new(board)
      (0..4).each do |i|
        player.play(i)
      end
      expect(board.winner?(4)).to eql("☻")
    end
    it "Detects diagonal win" do
      board = Board.new
      player = Player.new(board)
      (0..5).each do |i|
        i.times {player.play(i)}
      end
      expect(board.winner?(5)).to eql("☻")
    end
    it "Detects no winner" do
      board = Board.new
      expect(board.winner?(4)).to eql(false)
    end
  end
end

describe Player do
  describe "#initialize" do
    it "Generates a player, and ensures it generates a different symbol" do
      board = Board.new
      player = Player.new(board)
      expect(player.symbol).to eql("☻")
    end
  end

  describe "#play" do
    it "Makes a play, and fills the corresponding box with the player's icon" do
      board = Board.new
      player = Player.new(board)
      player.play(4)
      expect(board.state[3]).to eql(["O", "O", "O", "O", "O", "☻"])
    end
    it "With two players, both players should appear with different icons." do
      board = Board.new
      player = Player.new(board)
      player2 = Player.new(board)
      player.play(4)
      player2.play(4)
      expect(board.state[3]).to eql(["O", "O", "O", "O", "☺", "☻"])
    end
    it "Can't make a play if that column is full" do
      board = Board.new
      player = Player.new(board)
      7.times {player.play(4)}
      expect(player.play(4)).to eql(false)
    end
  end
end