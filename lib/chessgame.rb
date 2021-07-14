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
require_relative './chessgame_input'

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
    @chessgame_input = ChessGameInput.new
  end

  def play_game
    puts "CHESS\n"
    puts "Enter 1 to start a new game or 2 to load a saved game"

    user_input = @chessgame_input.player_input(1, 2)

    if user_input == 1 || (user_input == 2 && load_game.nil? )
      set_board
    end

    until game_over?
      display
      puts "#{@game_state[:current_turn]} - Select a piece to move: \n"
      touched_piece = @chessgame_input.player_piece_input(@game_state[:current_turn], @chess_board)

      puts "You have selected #{touched_piece.class} #{@@BOARD_RANK[touched_piece.pos[0]]}#{@@BOARD_FILE[touched_piece.pos[1]]}"
      puts "Enter 1 to select a new piece or 2 to enter a move: "
      user_input = @chessgame_input.player_input(1,2)
      next if user_input == 1

      puts "#{@game_state[:current_turn]} - Select space to move to: \n"
      new_pos = @chessgame_input.player_move_input
      get_move(new_pos, touched_piece)
      @game_state[:current_turn] = if @game_state[:current_turn] == 'white' then 'black' else 'white' end

    end
  end

  def get_move(new_pos, player_piece)
    loop do 
      if @chessgame_input.verify_move_input(new_pos, player_piece, @chess_board) == new_pos && !hypothetically_in_check?(new_pos, player_piece)

        if player_piece.class == Pawn
          player_piece.set_take_en_passant(new_pos, @chess_board)
          player_piece.take_en_passant(new_pos, @chess_board) if player_piece.t_e_p
          player_piece = promote_pawn(player_piece) if can_promote_pawn?(new_pos, player_piece)
        end

        @chess_board.find_node(new_pos).piece = player_piece
        @chess_board.find_node(player_piece.pos).piece = nil
        player_piece.has_moved = true if [Rook, Pawn, King].include?(player_piece.class)
  
        tep_pawn = find_pawn_tep
        tep_pawn.t_e_p = false if !tep_pawn.nil?

        player_piece.pos = new_pos
        return new_pos
      end

      puts "Input error! This move is not valid."
      puts "Enter 1 to select a new piece, or 2 to try another move: "
      user_input = @chessgame_input.player_input(1, 2)

      if user_input == 1
        puts "Select a new piece: "
        player_piece = @chessgame_input.player_piece_input(@game_state[:current_turn], @chess_board)
        puts "Enter a move:"
      else
        puts "Enter a new move"
      end
      new_pos = @chessgame_input.player_move_input
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

  def hypothetically_in_check?(new_pos, player_piece)
    current_pos = player_piece.pos
    player_piece.pos = new_pos
    @chess_board.find_node(new_pos).piece = player_piece
    @chess_board.find_node(current_pos).piece = nil
    result = player_king_in_check?
    player_piece.pos = current_pos

    result
  end

  def can_promote_pawn?(new_pos, player_piece)
    return true if player_piece.color == 'white' && new_pos[1] == 7 && player_piece.class == Pawn
    return true if player_piece.color == 'black' && new_pos[1] == 0 && player_piece.class == Pawn
    false
  end

  def promote_pawn(player_piece)
    puts "Select a piece to promote to - "
    puts "Enter 1 for queen, 2 for bishop, 3 for knight, 4 for rook: "
    user_input = @chessgame_input.player_input(1, 4)

    if user_input == 1
      player_piece = Queen.new(player_piece.pos, player_piece.color)
    elsif user_input == 2
      player_piece = Bishop.new(player_piece.pos, player_piece.color)
    elsif user_input == 3
      player_piece = Knight.new(player_piece.pos, player_piece.color)
    elsif user_input == 4
      player_piece = Rook.new(player_piece.pos, player_piece.color)
    end
    player_piece
  end

  private

  def move(new_pos, player_piece)
    node = @chess_board.find_node(new_pos).piece = player_piece
    @chess_board.find_node(player_piece.pos).piece = nil
    player_piece.pos = new_pos
    player_piece.has_moved = true 
  end

  def player_king_in_check?
    king = @chess_board.board.find { |node| node.piece.class == King && node.piece.color == @game_state[:current_turn] }.piece

    king.in_check?(@chess_board)
  end

  def find_pawn_tep
    pawn_node = @chess_board.board.find do |node|
      node.piece.class == Pawn && node.piece.color == @game_state[:current_turn] && node.piece.t_e_p
    end
    return pawn_node.piece if pawn_node
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

# c = ChessGame.new
# c.play_game


# c.load_game
# c.display

# node = c.chess_board.find_node([3,3])
# node.piece = Rook.new(node.coor, 'black')
# c.display
# c.save_game

