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
require_relative './computerplayer'
require_relative './chessgame'

chess_game = ChessGame.new
chess_game.play_game