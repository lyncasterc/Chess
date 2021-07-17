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
    
  end

  private

  def get_friendly_pieces
    nodes = @chess_board.board.filter { |node| !node.piece.nil? && node.piece.color == 'black' }
    pieces = nodes.collect { |node| node.piece }
    
    pieces
  end
end`