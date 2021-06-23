require_relative './gamepiece'

class Queen < GamePiece
  def initialize(pos = nil, color = nil)
    super(pos, color)
  end

  def valid_move?(new_pos, board)
    return false if board.off_board?(new_pos)
    return false if !board.is_linear?(@pos, new_pos) && !board.is_diagonal?(@pos, new_pos)
    return false if friendly_piece?(new_pos, board)
    return false if piece_in_path?(@pos, new_pos, board)
    true
  end
end


