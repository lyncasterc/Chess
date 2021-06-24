require_relative './gamepiece'
require_relative './board'

class Pawn < GamePiece
  def initialize(pos = nil, color = nil)
    super(pos, color)
  end

  def valid_move?(new_pos, board)
    x1 = @pos[0]
    y1 = @pos[1]
    x2 = new_pos[0]
    y2 = new_pos[1]

    return false if board.off_board?(new_pos)
    return false if friendly_piece?(new_pos, board)
    return false if y2 < y1 && @color == 'white'
    return false if y2 > y1 && @color == 'black'
    return false if (y2 - y1).abs() > 2


    # think i can with abs of 1 bc i already checked for backwards?
    true
  end
end

# b = Board.new
# bp = Pawn.new([3,3],'white')

# bp