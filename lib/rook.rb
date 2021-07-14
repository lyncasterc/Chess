# frozen_string_literal: true

require_relative './gamepiece'

# Represents a Rook on the board
class Rook < GamePiece
  attr_reader :unicode

  def initialize(pos = nil, color = nil, has_moved: false)
    super(pos, color, has_moved)
    @unicode = set_unicode
  end

  def valid_move?(new_pos, board)
    return false if board.off_board?(new_pos)
    return false unless board.horizontal_or_vertical?(@pos, new_pos)
    return false if friendly_piece?(new_pos, board)
    return false if piece_in_path?(@pos, new_pos, board)

    true
  end

  private

  def set_unicode
    @unicode = @color == 'white' ? '♖' : '♜'
  end
end
