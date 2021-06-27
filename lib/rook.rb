require_relative './gamepiece'

class Rook < GamePiece
  def initialize(pos = nil, color = nil, has_moved = false)
    super(pos, color, has_moved)
  end

  def valid_move?(new_pos, board)
    return false if board.off_board?(new_pos)
    return false if !board.is_linear?(@pos, new_pos) 
    return false if friendly_piece?(new_pos, board)
    return false if piece_in_path?(@pos, new_pos, board)
    true
  end
end
