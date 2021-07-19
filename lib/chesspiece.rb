# frozen_string_literal: true

# Base class for chess pieces
class ChessPiece
  attr_accessor :pos, :color, :has_moved

  def initialize(pos = nil, color = nil, has_moved = false)
    @pos = pos
    @color = color
    @has_moved = has_moved
  end

  def valid_move?(new_pos, board); end

  def piece_in_path?(start_pos, end_pos, board)
    path = nil

    if board.horizontal_or_vertical?(start_pos, end_pos)
      path = board.get_hori_vert_path(start_pos, end_pos)
    elsif board.diagonal?(start_pos, end_pos)
      path = board.get_diagonal_path(start_pos, end_pos)
    end
    
    return if path.nil?
    return false if path.empty?
    return false if path.all? { |node| node.piece.nil? }

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
