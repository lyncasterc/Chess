class GamePiece
  attr_accessor :pos, :color
  def initialize(pos = nil, color = nil)
    @pos = pos
    @color = color
  end
end