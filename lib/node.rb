# frozen_string_literal: true

# Represents a space on a chessboard.
class Node
  attr_accessor :coor, :piece

  def initialize(coor, piece = nil)
    @coor = coor
    @piece = piece
  end
end
