#frozen_string_literal: true

require_relative './king'
require_relative './rook'
require_relative './pawn'
require_relative './bishop'
require_relative './queen'
require_relative './knight'
require_relative './chesspiece'
require_relative './board'
require_relative './node'
require_relative './chessgame_input'

# Computer chess player class
class ComputerPlayer
  attr_reader :chess_board

  def initialize(chess_board)
    @chess_board = chess_board
  end

  def make_move
    friendly_pieces = get_friendly_pieces
    pieces_with_moves = []
    best_moves = []    

    friendly_pieces.each do |piece|
      moves = piece.possible_moves(@chess_board).filter { |node| !hypothetically_in_check?(node.coor, piece) }
      pieces_with_moves << [piece, moves] unless moves.empty?
      spaces_with_enemies = moves.filter { |node| !node.piece.nil? && node.piece.color == 'white' }
      next if spaces_with_enemies.empty?
      
      best_moves << [piece, spaces_with_enemies.max_by { |node| get_piece_value(node.piece) }]
    end

    if best_moves.empty?
      random_piece = pieces_with_moves.sample
      return [random_piece[0], random_piece[1].sample]
    end

    best_moves.max_by { |piece_and_space| get_piece_value(piece_and_space[1].piece) }
  end

  private

  def get_piece_value(piece)
    if piece.instance_of?(Pawn)
      return 1
    elsif piece.instance_of?(Knight)
      return 3
    elsif piece.instance_of?(Bishop)
      return 3
    elsif piece.instance_of?(Rook)
      return 5
    elsif piece.instance_of?(Queen)
      return 9
    end
  end

  def hypothetically_in_check?(new_pos, player_piece)
    current_pos = player_piece.pos
    new_pos_node = @chess_board.find_node(new_pos)
    new_pos_piece = new_pos_node.piece

    hypothetical_move(new_pos, player_piece)
    result = player_piece.instance_of?(King) ? player_piece.in_check?(@chess_board) : get_king.in_check?(@chess_board)
    hypothetical_move(current_pos, player_piece)
    new_pos_node.piece = new_pos_piece

    result
  end

  def hypothetical_move(new_pos, player_piece)
    @chess_board.find_node(new_pos).piece = player_piece
    @chess_board.find_node(player_piece.pos).piece = nil
    player_piece.pos = new_pos
  end

  def get_friendly_pieces
    nodes = @chess_board.board.filter { |node| !node.piece.nil? && node.piece.color == 'black' }
    pieces = nodes.collect { |node| node.piece }
    
    pieces
  end

  def get_king
    get_friendly_pieces.find { |piece| piece.instance_of?(King) }
  end
end