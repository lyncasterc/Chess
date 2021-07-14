# frozen_string_literal: true

require_relative './chesspiece'
# Represents a queen on the board
class Queen < ChessPiece
  attr_reader :unicode

  def initialize(pos = nil, color = nil)
    super(pos, color)
    @unicode = set_unicode
  end

  def valid_move?(new_pos, board)
    return false if board.off_board?(new_pos)
    return false if !board.horizontal_or_vertical?(@pos, new_pos) && !board.diagonal?(@pos, new_pos)
    return false if friendly_piece?(new_pos, board)
    return false if piece_in_path?(@pos, new_pos, board)

    true
  end

  private

  def set_unicode
    @unicode = @color == 'white' ? '♕' : '♛'
  end
end
