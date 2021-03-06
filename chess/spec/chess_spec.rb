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
    it "Allows a piece from one colour to take another" do
      board = Board.new
      board.setpiece("a", 1, "Queen", "white")
      board.setpiece("a", 8, "Pawn", "black")
      board.move("a", 1, "a", 8)
      expect(board.grid[["a", 8]].piece.class.name).to eql("Queen")
      expect(board.grid[["a", 8]].piece.square.loc).to eql(["a", 8])
    end
    context "Moving piece is a pawn" do
      it "Can move diagonally if a piece of opposite color is there" do
        board = Board.new
        board.setpiece("a", 3, "Pawn", "black")
        board.setpiece("b", 2, "Pawn", "white")
        board.setpiece("c", 3, "Pawn", "black")
        expect(board.possible_moves("b", 2)).to eql(Set[["b", 3], ["b", 4], ["a", 3], ["c", 3]])
      end
    end
  end
  describe "#fillboard" do
    it "Fills the board with the starting pieces" do
      board = Board.new
      board.fillboard
      ("abcdefgh").each_char do |c|
        (1..8).each do |v|
          if v == 2 || v == 7
            expect(board.grid[[c, v]].piece.class.name).to eql("Pawn")
          elsif v == 1 || v == 8
            if c == "a" || c == "h"
              expect(board.grid[[c, v]].piece.class.name).to eql("Rook")
            elsif c == "b" || c == "g"
              expect(board.grid[[c, v]].piece.class.name).to eql("Knight")
            elsif c == "c" || c == "f"
              expect(board.grid[[c, v]].piece.class.name).to eql("Bishop")
            elsif c == "d"
              expect(board.grid[[c, v]].piece.class.name).to eql("Queen")
            elsif c == "e"
              expect(board.grid[[c, v]].piece.class.name).to eql("King")
            end
          end
          if v == 1 || v == 2
            expect(board.grid[[c, v]].piece.color).to eql("white")
          elsif v == 7 || v == 8
            expect(board.grid[[c, v]].piece.color).to eql("black")
          end
        end
      end
    end
  describe "#check?" do
    it "Determines whether a king is in check" do
      board = Board.new
      board.setpiece("a", 1, "King", "white")
      board.setpiece("b", 2, "Bishop", "black")
      expect(board.check?("a", 1, "white")).to eql(true)
      end
    end
  end
  describe "#checkmate?" do
    it "Determines whether a king is checkmate" do
      board = Board.new
      board.setpiece("b", 2, "King", "white")
      board.setpiece("b", 1, "Queen", "white")
      board.setpiece("a", 1, "Pawn", "white")
      board.setpiece("a", 2, "Rook", "white")
      board.setpiece("a", 3, "Pawn", "white")
      board.setpiece("c", 3, "Pawn", "white")
      board.setpiece("c", 2, "Pawn", "white")
      board.setpiece("c", 1, "Pawn", "white")
      board.setpiece("b", 4, "Rook", "black")
      expect(board.checkmate?("b", 2, "white")).to eql(true)
    end
    it "Can return negative" do
      board = Board.new
      board.setpiece("b", 2, "King", "white")
      board.setpiece("b", 1, "Queen", "white")
      board.setpiece("a", 1, "Pawn", "white")
      board.setpiece("a", 3, "Pawn", "white")
      board.setpiece("c", 3, "Pawn", "white")
      board.setpiece("c", 2, "Pawn", "white")
      board.setpiece("c", 1, "Pawn", "white")
      board.setpiece("b", 4, "Rook", "black")
      expect(board.checkmate?("b", 2, "white")).to eql(false)
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
    it "Possible moves does not include boxes occupied by same color" do
      board = Board.new
      board.setpiece("a", 1, "King", "black")
      board.setpiece("a", 2, "Pawn", "black")
      board.setpiece("b", 2, "Pawn", "black")
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
  describe "#kill" do
    it "When a piece is taken, it is no longer in the class variable" do
      board = Board.new
      board.setpiece("a", 1, "Queen", "black")
      expect(board.getall("black")).to eql([board.grid[["a", 1]].piece])
      board.setpiece("a", 2, "Rook", "white")
      board.move("a", 2, "a", 1)
      expect(board.getall("black")).to eql([])
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
      expect(board.possible_moves("a", 1)).to eql(Set[["a", 2], ["a", 3]])
      board.move("a", 1, "a", 3)
      expect(board.possible_moves("a", 3)).to eql(Set[["a", 4]])
    end
    it "Can do a 2 step move if it is the pawn's first move." do
      board = Board.new
      board.fillboard
      expect(board.possible_moves("a", 2)).to eql(Set[["a", 3], ["a", 4]])
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