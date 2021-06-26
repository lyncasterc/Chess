require_relative './gamepiece'
require_relative './board'

class King < GamePiece
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
    return false if (y2 - y1).abs() > 1
    return false if (x2 - x1).abs() > 1 #&& !can_castle?
    
  
    true
  end


end

b = Board.new
k = King.new([3,3],'black')

