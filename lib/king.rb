require_relative './chesspiece'
require_relative './rook'
require_relative './board'

class King < ChessPiece
  attr_reader :unicode
  
  def initialize(pos = nil, color = nil, has_moved = false)
    super(pos, color, has_moved)
    @unicode = set_unicode
  end

  def valid_move?(new_pos, board)
    x1 = @pos[0]
    y1 = @pos[1]
    x2 = new_pos[0]
    y2 = new_pos[1]

    return false if board.off_board?(new_pos)
    return false if friendly_piece?(new_pos, board)
    return false if in_check?(board, new_pos)
    return false if (y2 - y1).abs() > 1
    return false if (x2 - x1).abs() > 2 
    return false if (x2 - x1).abs() == 2 && !can_castle?(board, new_pos)
  
    true
  end

  def in_check?(board, pos = @pos)
    enemy_pieces = board.board.filter { |node| node.piece.class != King && enemy_piece?(node.coor, board) }
    
    possible_enemy_moves = enemy_pieces.collect { |node| node.piece.possible_moves(board) }

    possible_enemy_moves.each do |arr|
      return true if arr.any? { |node| node.coor == pos }
    end

    false
  end

  def can_castle?(board, castle_pos)
    x1 = @pos[0]
    x2 = castle_pos[0]
    castle_rook = nil
    castle_path = board.get_linear_path(@pos, castle_pos)

    if @color == 'black'
      black_piece = board.find_node([7,7]).piece if x2 > x1 
      black_piece = board.find_node([0,7]).piece if x2 < x1

      castle_rook = black_piece if black_piece.class == Rook
    else
      white_piece = board.find_node([7,0]).piece if x2 > x1 
      white_piece = board.find_node([0,0]).piece if x2 < x1

      castle_rook = white_piece if white_piece.class == Rook
    end  

    return false if !castle_rook
    return false if @has_moved || castle_rook.has_moved
    return false if in_check?(board) || in_check?(board, castle_pos)
    castle_path.each do |node|
      return false if in_check?(board, node.coor)
    end
    return false if piece_in_path?(@pos, castle_pos, board)

    true
  end

  private
  def set_unicode
    @color == 'white' ? @unicode = '♔' : @unicode = '♚'
  end
  
end

# b = Board.new
# bk = King.new([4,7],'black')

# black_rook_1 = Rook.new([7,7], 'black') 
# black_rook_2 = Rook.new([0,7], 'black') 
# white_rook_1 = Rook.new([7,0], 'white') 
# white_rook_2 = Rook.new([0,0], 'white')

# b.board.each do |node|
#   if node.coor == [0,0]
#     node.piece = white_rook_2
#   elsif node.coor == [7,0]
#     node.piece = white_rook_1
#   elsif node.coor == [0,7]
#     node.piece = black_rook_2
#   elsif node.coor == [7,7]
#     node.piece = black_rook_1
#   end
# end

# print bk.can_castle?(b, [6,7])