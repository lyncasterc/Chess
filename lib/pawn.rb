# frozen_string_literal: true

require_relative './chesspiece'
# Represents a pawn on the board
class Pawn < ChessPiece
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
    # backward moves
    return false if y2 < y1 && @color == 'white'
    return false if y2 > y1 && @color == 'black'
    # y's can not change by more than 2
    return false if (y2 - y1).abs > 2
    # x's can not change by more than 2
    return false if (x2 - x1).abs > 1

    # can not move 2 if pawn has moved already
    # can not move 2 if piece is the way
    if (y2 - y1).abs == 2
      return false if (x2 - x1).abs.positive?
      return false if @has_moved || piece_in_path?(@pos, new_pos, board)
    end

    # can not move horizontally if not diagonal
    # can not move diagonally by one if there is no enemy piece and can not take en passant
    if (x2 - x1).abs == 1
      return false unless board.diagonal?(@pos, new_pos)
      return false if !enemy_piece?(new_pos, board) && !@t_e_p
      
      if @t_e_p
        return false if !enemy_piece?([new_pos[0], new_pos[1] - 1], board) && @color == 'black'
        return false if !enemy_piece?([new_pos[0], new_pos[1] + 1], board) && @color == 'white'
      end
    end

    true
  end

  def set_take_en_passant(new_pos, board)
    if (new_pos[1] - @pos[1]).abs == 2
      adjacent_positions = [[new_pos[0] + 1, new_pos[1]], [new_pos[0] - 1, new_pos[1]]]

      adjacent_positions.each do |pos|
        next if board.off_board?(pos)

        pos_node = board.find_node(pos)

        if pos_node.piece.instance_of?(Pawn) && enemy_piece?(pos, board)
          enemy_pawn = pos_node.piece
          enemy_pawn.t_e_p = true
        end
      end
    end
  end

  def take_en_passant(new_pos, board)
    adjacent_positions = [[@pos[0] + 1, @pos[1]], [@pos[0] - 1, @pos[1]]]
    adjacent_positions.collect! { |position| board.find_node(position) }
    enemy_pawn_node = adjacent_positions.find { |node| node.piece.instance_of?(Pawn) && enemy_piece?(node.coor, board) }

    if @color == 'black' && new_pos == [enemy_pawn_node.coor[0], enemy_pawn_node.coor[1] - 1]
      enemy_pawn_node.piece = nil
    elsif @color == 'white' && new_pos == [enemy_pawn_node.coor[0], enemy_pawn_node.coor[1] + 1]
      enemy_pawn_node.piece = nil
    end
    @t_e_p = false
    new_pos
  end

  private

  def set_unicode
    @unicode = @color == 'white' ? '♙' : '♟︎'
  end
end
