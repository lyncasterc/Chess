require_relative './gamepiece'

class Pawn < GamePiece
  attr_accessor :t_e_p
  attr_reader :unicode

  def initialize(pos = nil, color = nil, has_moved = false)
    super(pos, color, has_moved)
    @t_e_p = false # can pawn take en passant?
    @unicode = set_unicode
  end

  def valid_move?(new_pos, board)
    x1 = @pos[0]
    y1 = @pos[1]
    x2 = new_pos[0]
    y2 = new_pos[1]

    return false if board.off_board?(new_pos)
    return false if friendly_piece?(new_pos, board)
    #backward moves
    return false if y2 < y1 && @color == 'white' 
    return false if y2 > y1 && @color == 'black'
    # y's can not change by more than 2
    return false if (y2 - y1).abs() > 2 
    # x's can not change by more than 2
    return false if (x2 - x1).abs() > 1

    # can not move 2 if pawn has moved already
    # can not move 2 if piece is the way 
    if(y2 - y1).abs() == 2
      return false if (x2 - x1).abs() > 0
      return false if @has_moved || piece_in_path?(@pos, new_pos, board)
    end
    
    #can not move horizontally if not diagonal
    #can not move diagonally by one if there is no enemy piece and can not take en passant
    if (x2 - x1).abs() == 1
      return false if !board.is_diagonal?(@pos, new_pos)
      return false if !enemy_piece?(new_pos, board) && !@t_e_p
    end

    true
  end
  private
  def set_unicode
    @color == 'white' ? @unicode = '♗' : @unicode = '♝'
  end
end

