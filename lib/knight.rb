# frozen_string_literal: true

require_relative './chesspiece'

# Represents a knight on the board
class Knight < ChessPiece
  attr_reader :unicode

  def initialize(pos = nil, color = nil)
    super(pos, color)
    @unicode = set_unicode
  end

  def valid_move?(new_pos, board)
    x1 = @pos[0]
    y1 = @pos[1]
    x2 = new_pos[0]
    y2 = new_pos[1]

    return false if board.off_board?(new_pos)
    return false if friendly_piece?(new_pos, board)

    if (x2 - x1).abs == 2 && (y2 - y1).abs == 1
      return true
    elsif (y2 - y1).abs == 2 && (x2 - x1).abs == 1
      return true
    end

    false
  end

  private

  def set_unicode
    @unicode = @color == 'white' ? '♘' : '♞'
  end
end
