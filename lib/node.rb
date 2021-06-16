class Node
  attr_accessor :coor, :piece
  def initialize(coor, piece=nil)
    @coor = coor
    @piece = piece
  end
end