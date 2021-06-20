require_relative './node'

class Board
  attr_reader :board

  def initialize
    @board = create_board
  end

  def find_node(pos)
    @board.find {|node| node.coor == pos} 
  end

  def off_board?(pos)
    x1 = pos[0]
    y1 = pos[1]
    return true if x1 > 7 || x1 < 0 || y1 > 7 || y1 < 0
    false
  end

  def is_linear?(start_pos, end_pos)
    x1 = start_pos[0]
    y1 = start_pos[1]
    x2 = end_pos[0]
    y2 = end_pos[1]

    return false if x2 != x1 && y2 != y1 
    true
  end

  def is_diagonal?(start_pos, end_pos)
    x1 = start_pos[0]
    y1 = start_pos[1]
    x2 = end_pos[0]
    y2 = end_pos[1]
    slope = (y2 - y1) / (x2 - x1)

    return true if slope.abs() == 1 
    false
  end

  def get_linear_path(start_pos, end_pos)
    path = []
    x1 = start_pos[0]
    y1 = start_pos[1]
    x2 = end_pos[0]
    y2 = end_pos[1]

    if x2 == x1
      if y2 > y1
        until y1 >= y2 - 1
          y1 += 1
          path.push(find_node([x1, y1]))
        end 
      elsif y2 < y1
        until y2 >= y1 - 1
          y2 += 1
          path.push(find_node([x1, y2]))
        end
      end

    elsif y2 == y1
      if x2 > x1
        until x1 >= x2 - 1
          x1 += 1
          path.push(find_node([x1, y1]))
        end 
      elsif x2 < x1
        until x2 >= x1 - 1
          x2 += 1
          path.push(find_node([x2, y1]))
        end
      end
    end
    path
  end

  def get_diagonal_path(start_pos, end_pos)
    path = []
    x1 = start_pos[0]
    y1 = start_pos[1]
    x2 = end_pos[0]
    y2 = end_pos[1]

    if x2 > x1 && y2 > y1
      until x1 >= x2 - 1 do
        x1 += 1
        y1 += 1
        path.push(find_node([x1, y1]))
      end

    elsif x2 < x1 && y2 < y1
      until x2 >= x1 - 1 do
        x2 += 1
        y2 += 1
        path.push(find_node([x2,y2]))
      end
    
    elsif x2 < x1 && y2 > y1 
      until y1 >= y2 - 1 do
        y1 += 1
        x1 -= 1
        path.push(find_node([x1, y1]))
      end

    elsif x2 > x1 && y2 < y1
      until y2 >= y1 - 1 do
        y2 += 1
        x2 -= 1
        path.push(find_node([x2,y2]))
      end
    end
    path
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


