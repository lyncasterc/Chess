require_relative './gamepiece'

class Rook < GamePiece
  def initialize(pos = nil, color = nil)
    super(pos, color)
  end
end

