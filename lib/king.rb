# frozen_string_literal: true

require_relative './chesspiece'
require_relative './rook'
require_relative './board'

# Represents a king on the board
class King < ChessPiece
  attr_reader :unicode

  def initialize(pos = nil, color = nil, has_moved = false)
    super(pos, color, has_moved)
    @unicode = set_unicode
  end

  def valid_move?(new_pos, board)
    x1 = @pos[0]
    y1 = @pos[1]
    x2 = new_pos[0]
    y2 = new_pos[1]
    
    return false if board.off_board?(new_pos)
    return false if friendly_piece?(new_pos, board)
    return false if (y2 - y1).abs > 1
    return false if (x2 - x1).abs > 2
    return false if (x2 - x1).abs == 2 && !can_castle?(board, new_pos)
    
    true
  end

  def in_check?(board, pos = @pos)
    enemy_pieces = board.board.filter { |node| enemy_piece?(node.coor, board) && !node.piece.instance_of?(King) }
    possible_enemy_moves = enemy_pieces.collect { |node| node.piece.possible_moves(board) }    

    possible_enemy_moves.each do |arr|
      return true if arr.any? { |node| node.coor == pos }
    end

    false
  end

  def can_castle?(board, castle_pos)
    x1 = @pos[0]
    x2 = castle_pos[0]
    castle_rook = nil
    castle_path = board.get_hori_vert_path(@pos, castle_pos)

    if @color == 'black'
      black_piece = board.find_node([7, 7]).piece if x2 > x1
      black_piece = board.find_node([0, 7]).piece if x2 < x1

      castle_rook = black_piece if black_piece.instance_of?(Rook)
    else
      white_piece = board.find_node([7, 0]).piece if x2 > x1
      white_piece = board.find_node([0, 0]).piece if x2 < x1

      castle_rook = white_piece if white_piece.instance_of?(Rook)
    end

    return false unless castle_rook
    return false if @has_moved || castle_rook.has_moved
    return false if in_check?(board) || in_check?(board, castle_pos)
    
    castle_path.each do |node|
      return false if in_check?(board, node.coor)
    end
    return false if piece_in_path?(@pos, castle_pos, board)

    true
  end

  private

  def set_unicode
    @unicode = @color == 'white' ? '♔' : '♚'
  end
end
