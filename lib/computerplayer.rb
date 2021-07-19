# frozen_string_literal: true

require_relative './king'
require_relative './rook'
require_relative './pawn'
require_relative './bishop'
require_relative './queen'
require_relative './knight'
require_relative './chesspiece'
require_relative './board'
require_relative './node'

# Computer chess player class
class ComputerPlayer
  attr_reader :chess_board

  def initialize(chess_board)
    @chess_board = chess_board
  end

  def generate_move
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
      1
    elsif piece.instance_of?(Knight)
      3
    elsif piece.instance_of?(Bishop)
      3
    elsif piece.instance_of?(Rook)
      5
    elsif piece.instance_of?(Queen)
      9
    end
  end

  def hypothetically_in_check?(new_pos, player_piece)
    result = false
    current_pos = player_piece.pos
    new_pos_node = @chess_board.find_node(new_pos)
    new_pos_piece = new_pos_node.piece

    hypothetical_move(new_pos, player_piece)

    if player_piece.instance_of?(King)
      result = true if player_piece.in_check?(@chess_board) || can_enemy_king_check?
    else 
      result = true if get_king.in_check?(@chess_board)
    end

    hypothetical_move(current_pos, player_piece)
    new_pos_node.piece = new_pos_piece

    result
  end

  # returns true if the enemy king could check the player king
  def can_enemy_king_check?
    friendly_king = get_king
    enemy_king = @chess_board.board.find do |node|
      !node.piece.nil? && node.piece.instance_of?(King) && node.piece.color == 'white'
    end
    return unless enemy_king

    enemy_king = enemy_king.piece
    enemy_king.possible_moves(@chess_board).each do |node|
      return true if node.coor == friendly_king.pos
    end
    
    false
  end

  def hypothetical_move(new_pos, player_piece)
    @chess_board.find_node(new_pos).piece = player_piece
    @chess_board.find_node(player_piece.pos).piece = nil
    player_piece.pos = new_pos
  end

  def get_friendly_pieces
    nodes = @chess_board.board.filter { |node| !node.piece.nil? && node.piece.color == 'black' }
    nodes.collect(&:piece)
  end

  def get_king
    get_friendly_pieces.find { |piece| piece.instance_of?(King) }
  end
end
