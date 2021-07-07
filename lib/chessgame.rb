require_relative './king'
require_relative './rook'
require_relative './pawn'
require_relative './bishop'
require_relative './queen'
require_relative './queen'
require_relative './knight'
require_relative './gamepiece'
require_relative './board'
require_relative './node'

class ChessGame
  # attr_accessor :chess_board, :game_state
  @@BOARD_RANK = ('a'..'h').to_a
  @@BOARD_FILE = ('1'..'8').to_a

  def initialize
    @chess_board = nil
    @game_state = {
      moves: 0,
      current_turn: 'white',
      draw: false,
      resign: false

    }
  end

  def play_game
    puts "CHESS\n"
    puts "Enter 1 to start a new game or 2 to load a saved game"

    input = player_input(1, 2)

    if input == 1 || (input == 2 && load_game.nil? )
      set_board
    end

    until game_over?
      display
      puts "#{@game_state[:current_turn]} - Select a piece to move: \n"
      touched_piece = player_piece_input
      puts "#{@game_state[:current_turn]} - Select space to move to: \n"
      new_pos = player_move_input
      move(touched_piece, new_pos)
      @game_state[:current_turn] = if @game_state[:current_turn] == 'white' then 'black' else 'white' end

    end
  end

  private
  def verify_input(min, max, input)
    return input if input.between?(min, max)
  end

  def player_input(min, max)
    loop do
      user_input = gets.chomp.to_i
      verified_number = verify_input(min, max, user_input)
      return verified_number if !verified_number.nil?

      puts "Input error! Please enter a number between #{min} and #{max}."
    end
  end

  def verify_pos_input(input)
    return convert_coor(input) if @@BOARD_RANK.include?(input[0].downcase) && @@BOARD_FILE.include?(input[1])
  end

  def verify_player_piece(piece_pos)
    player_piece = @chess_board.find_node(piece_pos).piece if !piece_pos.nil?
    return player_piece if !player_piece.nil? && player_piece.color == @game_state[:current_turn]
  end
  
  def player_piece_input
    loop do
      user_input = gets.chomp
      verified_input = verify_pos_input(user_input)
      verified_piece = verify_player_piece(verified_input)
      return verified_piece if !verified_piece.nil?

      puts "Input error! Check that your entered position is correct."
    end
  end

  def verify_move_input(player_piece, new_pos)
    return new_pos if !new_pos.nil? && player_piece.valid_move?(new_pos, @chess_board)
  end

  def player_move_input(player_piece)
    loop do
      user_input = gets.chomp
      verified_input = verify_pos_input(user_input)
      verified_move = verify_move_input(player_piece, verified_input)
      return verified_move if !verified_move.nil? 

      puts "Input error! This move is not valid."
    end
  end

  def display
    gray_space = '|#'
    white_space = '|_'

    if !@chess_board.nil?
      7.step(0,-1) do |y|
        print "#{y + 1} "
        8.times do |x|
          node = @chess_board.find_node([x,y])
  
          if !node.piece.nil?
            print '|' + node.piece.unicode
          elsif node.coor[1] % 2 == 0 
            if node.coor[0] % 2 == 0
              print gray_space
            else
              print white_space
            end
          elsif node.coor[1] % 2 != 0
            if node.coor[0] % 2 != 0
              print gray_space
            else
              print white_space
            end  
          end
  
        end
        puts "|"
      end
      puts '   a b c d e f g h'
    end
  end

  def move(player_piece, new_pos)
    @chess_board.find_node(player_piece.pos).piece = nil
    player_piece.has_moved = true if [Rook, Pawn, King].include?(player_piece.class)

    if player_piece.class == Pawn
      player_piece.set_take_en_passant(new_pos, @chess_board)
      player_piece.t_e_p = false if player_piece.t_e_p && player_piece.take_en_passant(new_pos, @chess_board).nil?
    end
    
    player_piece.pos = new_pos
  end

  def game_over?
    kings = @chess_board.board.filter { |node| !node.piece.nil? && node.piece.class == King }
    kings.collect! { |node| node.piece }

    #checking for a mate
    return true if kings.any? { |king| king.in_check?(@chess_board) && king.possible_moves(@chess_board).empty?}

    #game is drawn or resigned
    return true if @game_state[:draw] || @game_state[:resign]

    false
  end

  def convert_coor(chess_coor)
    coor = []
    chess_coor = chess_coor.split('')
    coor.push(@@BOARD_RANK.find_index(chess_coor[0]))
    coor.push(@@BOARD_FILE.find_index(chess_coor[1]))

    coor
  end
  
  def set_board
    @chess_board = Board.new
    @chess_board.board.each do |node|

      if node.coor == [0,0]
        node.piece = Rook.new([0,0], 'white')
      elsif node.coor == [1,0]
        node.piece = Knight.new([1,0], 'white')
      elsif node.coor == [2,0]
        node.piece = Bishop.new([2,0], 'white')
      elsif node.coor == [3,0]
        node.piece = Queen.new([3,0], 'white')
      elsif node.coor == [4,0]
        node.piece = King.new([4,0], 'white')
      elsif node.coor == [5,0]
        node.piece = Bishop.new([5,0], 'white')
      elsif node.coor == [6,0]
        node.piece = Knight.new([6,0], 'white')
      elsif node.coor == [7,0]
        node.piece = Rook.new([7,0], 'white')
      elsif node.coor[1] == 1
        node.piece = Pawn.new(node.coor, 'white')
        
      elsif node.coor[1] == 6
        node.piece = Pawn.new(node.coor, 'black')
      elsif node.coor == [0,7]
        node.piece = Rook.new([0,7], 'black')
      elsif node.coor == [1,7]
        node.piece = Knight.new([1,7], 'black')
      elsif node.coor == [2,7]
        node.piece = Bishop.new([2,7], 'black')
      elsif node.coor == [3,7]
        node.piece = Queen.new([3,7], 'black')
      elsif node.coor == [4,7]
        node.piece = King.new([4,7], 'black')
      elsif node.coor == [5,7]
        node.piece = Bishop.new([5,7], 'black')
      elsif node.coor == [6,7]
        node.piece = Knight.new([6,7], 'black')
      elsif node.coor == [7,7]
        node.piece = Rook.new([7,7], 'black')
      end
    end
  end

  def save_game
    require "yaml"

    File.open("lib/chessgame_save.yaml", "w") do |file|
      file.write YAML::dump(@game_state)
      file.write YAML::dump(@chess_board)
    end
  end

  def load_game
    require "yaml"
    
    if File.zero?("lib/chessgame_save.yaml")
      return nil
    else
      f = File.open("lib/chessgame_save.yaml")
      objects = YAML::load_stream(f)
      f.close
      
      @game_state = objects[0]
      @chess_board = objects[1]
    end
  end
end

c = ChessGame.new

c.play_game

# c.load_game
# c.display

# node = c.chess_board.find_node([3,3])
# node.piece = Rook.new(node.coor, 'black')
# c.display
# c.save_game







