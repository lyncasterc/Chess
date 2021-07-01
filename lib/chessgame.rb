require_relative './king'
require_relative './rook'
require_relative './pawn'
require_relative './bishop'
require_relative './queen'
require_relative './queen'
require_relative './knight'
require_relative './gamepiece'
require_relative './board'
require_relative './node'

class ChessGame
  attr_reader :chess_board
  @@board_rank = ('a'..'h').to_a
  @@board_file = ('1'..'8').to_a

  def initialize
    @chess_board = Board.new
    set_board
  end

  def display
    gray_space = '|#'
    white_space = '|_'

    7.step(0,-1) do |y|
      print "#{y + 1} "
      8.times do |x|
        node = chess_board.find_node([x,y])

        if !node.piece.nil?
          print '|' + node.piece.unicode
        elsif node.coor[1] % 2 == 0 
          if node.coor[0] % 2 == 0
            print gray_space
          else
            print white_space
          end
        elsif node.coor[1] % 2 != 0
          if node.coor[0] % 2 != 0
            print gray_space
          else
            print white_space
          end  
        end

      end
      puts "|"
    end
    puts '   a b c d e f g h'
  end

  # def move(start, end)

  # end

  def convert_coor(chess_coor)
    coor = []
    chess_coor = chess_coor.split('')
    coor.push(@@board_rank.find_index(chess_coor[0]))
    coor.push(@@board_file.find_index(chess_coor[1]))

    coor
  end

  private
  def set_board
    @chess_board.board.each do |node|

      if node.coor == [0,0]
        node.piece = Rook.new([0,0], 'white')
      elsif node.coor == [1,0]
        node.piece = Knight.new([1,0], 'white')
      elsif node.coor == [2,0]
        node.piece = Bishop.new([2,0], 'white')
      elsif node.coor == [3,0]
        node.piece = Queen.new([3,0], 'white')
      elsif node.coor == [4,0]
        node.piece = King.new([4,0], 'white')
      elsif node.coor == [5,0]
        node.piece = Bishop.new([5,0], 'white')
      elsif node.coor == [6,0]
        node.piece = Knight.new([6,0], 'white')
      elsif node.coor == [7,0]
        node.piece = Rook.new([7,0], 'white')
      elsif node.coor[1] == 1
        node.piece = Pawn.new(node.coor, 'white')
        
      elsif node.coor[1] == 6
        node.piece = Pawn.new(node.coor, 'black')
      elsif node.coor == [0,7]
        node.piece = Rook.new([0,7], 'black')
      elsif node.coor == [1,7]
        node.piece = Knight.new([1,7], 'black')
      elsif node.coor == [2,7]
        node.piece = Bishop.new([2,7], 'black')
      elsif node.coor == [3,7]
        node.piece = Queen.new([3,7], 'black')
      elsif node.coor == [4,7]
        node.piece = King.new([4,7], 'black')
      elsif node.coor == [5,7]
        node.piece = Bishop.new([5,7], 'black')
      elsif node.coor == [6,7]
        node.piece = Knight.new([6,7], 'black')
      elsif node.coor == [7,7]
        node.piece = Rook.new([7,7], 'black')
      end
    end
  end

  
end

c = ChessGame.new
c.display


