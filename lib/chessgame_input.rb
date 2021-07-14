# frozen_string_literal: true

require_relative './king'
require_relative './rook'
require_relative './pawn'
require_relative './bishop'
require_relative './queen'
require_relative './knight'
require_relative './gamepiece'
require_relative './board'
require_relative './node'

# Gets all ChessGame inputs from user
class ChessGameInput
  @@BOARD_RANK = ('a'..'h').to_a
  @@BOARD_FILE = ('1'..'8').to_a

  def verify_input(min, max, input)
    return input if input.between?(min, max)
  end

  def player_input(min, max)
    loop do
      user_input = gets.chomp.to_i
      verified_number = verify_input(min, max, user_input)
      return verified_number unless verified_number.nil?

      puts "Input error! Please enter a number between #{min} and #{max}."
    end
  end

  def verify_player_piece(piece_pos, current_turn, board)
    player_piece = board.find_node(piece_pos).piece unless piece_pos.nil?
    return player_piece if !player_piece.nil? && player_piece.color == current_turn
  end

  def player_piece_input(current_turn, board)
    loop do
      user_input = gets.chomp
      verified_input = verify_pos_input(user_input)
      verified_piece = verify_player_piece(verified_input, current_turn, board)
      return verified_piece unless verified_piece.nil?

      puts 'Input error! Check that your entered position is correct.'
    end
  end

  def verify_move_input(new_pos, player_piece, board)
    return new_pos if !new_pos.nil? && player_piece.valid_move?(new_pos, board)
  end

  def verify_pos_input(input)
    return convert_coor(input) if @@BOARD_RANK.include?(input[0].downcase) && @@BOARD_FILE.include?(input[1])
  end

  def player_move_input
    loop do
      user_input = gets.chomp
      verified_input = verify_pos_input(user_input)
      return verified_input unless verified_input.nil?

      puts 'Input error! This move is not valid.'
    end
  end

  def convert_coor(chess_coor)
    coor = []
    chess_coor = chess_coor.split('')
    coor.push(@@BOARD_RANK.find_index(chess_coor[0]))
    coor.push(@@BOARD_FILE.find_index(chess_coor[1]))

    coor
  end
end
