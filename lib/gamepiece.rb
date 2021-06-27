class GamePiece
  attr_accessor :pos, :color
  def initialize(pos = nil, color = nil)
    @pos = pos
    @color = color
  end

  def valid_move?(new_pos, board)
  end

  def has_moved?
  end

  def piece_in_path?(start_pos, end_pos, board)
    if board.is_linear?(start_pos, end_pos)
      path = board.get_linear_path(start_pos, end_pos)
    elsif board.is_diagonal?(start_pos, end_pos)
      path = board.get_diagonal_path(start_pos,end_pos)
    end

    return false if path.length < 1
    return false if path.all? {|node| node.piece.nil?}
    true
  end

  def friendly_piece?(new_pos, board)
    new_pos_node = board.find_node(new_pos)
    return true if !new_pos_node.piece.nil? && new_pos_node.piece.color == @color

    false
  end

  def enemy_piece?(new_pos, board)
    new_pos_node = board.find_node(new_pos)
    return true if !new_pos_node.piece.nil? && new_pos_node.piece.color != @color
    
    false
  end

  def possible_moves(board)
    board.board.filter { |node| valid_move?(node.coor, board) && node.coor != @pos }
  end

end

