require_relative './gamepiece'

class Rook < GamePiece
  def initialize(pos = nil, color = nil)
    super(pos, color)
  end

  def valid_move?(new_pos, board)
    return false if board.off_board?(new_pos)
    return false if !board.is_linear?(@pos, new_pos) 
    return false if friendly_piece?(new_pos, board)
    return false if piece_in_path?(@pos, new_pos, board)
    true
  end

  # def get_path(start_pos, end_pos, board)
  #   path = []
  #   x1 = start_pos[0]
  #   y1 = start_pos[1]
  #   x2 = end_pos[0]
  #   y2 = end_pos[1]

  #   if x2 == x1
  #     if y2 > y1
  #       until y1 >= y2 - 1
  #         y1 += 1
  #         path.push(board.find_node([x1, y1]))
  #       end 
  #     elsif y2 < y1
  #       until y2 >= y1 - 1
  #         y2 += 1
  #         path.push(board.find_node([x1, y2]))
  #       end
  #     end

  #   elsif y2 == y1
  #     if x2 > x1
  #       until x1 >= x2 - 1
  #         x1 += 1
  #         path.push(board.find_node([x1, y1]))
  #       end 
  #     elsif x2 < x1
  #       until x2 >= x1 - 1
  #         x2 += 1
  #         path.push(board.find_node([x2, y1]))
  #       end
  #     end
  #   end
  #   path
  # end

end
