require_relative './node'

class Board
  attr_reader :board

  def initialize
    @board = create_board
  end

  private
  def create_board
    a = Array.new(8){|i| i}
    board = []

    a.each do |x|
      a.each do |y|
        board.push(Node.new(coor = [x,y]))
      end
    end
    return board
  end
end
