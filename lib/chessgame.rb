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
require_relative './chessgame_input'
require_relative './computerplayer'

# Chess game class
class ChessGame
  @@BOARD_RANK = ('a'..'h').to_a
  @@BOARD_FILE = ('1'..'8').to_a

  def initialize
    @chess_board = Board.new
    @computer = ComputerPlayer.new(@chess_board)
    @game_state = {
      moves: 0,
      current_turn: 'white',
      draw: false,
      resign: nil,
      mate: nil,
      stalemate: false,
      move_history: []
    }
    @chessgame_input = ChessGameInput.new
  end

  def play_game
    puts "CHESS\n"
    puts 'Enter 1 to start a new game or 2 to load a saved game'

    user_input = @chessgame_input.player_input(1, 2)

    set_board if user_input == 1 || (user_input == 2 && load_game.nil?)

    until game_over?
      display
      puts "#{@game_state[:current_turn]} - Select a piece to move: \n"
      touched_piece = @chessgame_input.player_piece_input(@game_state[:current_turn], @chess_board)

      puts "You have selected #{touched_piece.class} #{@@BOARD_RANK[touched_piece.pos[0]]}#{@@BOARD_FILE[touched_piece.pos[1]]}"

      menu_choice = get_menu_choice
      next if menu_choice == 1
      break if menu_choice == 5

      puts "#{@game_state[:current_turn]} - Select space to move to: \n\n"
      new_pos = @chessgame_input.player_move_input
      get_move(new_pos, touched_piece)


      @game_state[:current_turn] = 'black'
      make_computer_move
      @game_state[:current_turn] = 'white'
    end
    display
    puts game_over_message
  end

  def get_move(new_pos, player_piece)
    loop do
      if @chessgame_input.verify_move_input(new_pos, player_piece,
                                            @chess_board) == new_pos && !hypothetically_in_check?(new_pos, player_piece)

        pawn_move_actions(new_pos, player_piece) if player_piece.instance_of?(Pawn)
        castle(new_pos, player_piece) if player_piece.instance_of?(King)
        
        tep_pawn = find_pawn_tep
        tep_pawn.t_e_p = false unless tep_pawn.nil?
        log_move(new_pos, player_piece)
        move(new_pos, player_piece)
        player_piece.has_moved = true

        return new_pos
      end

      puts 'Input error! This move is not valid.'
      puts 'Enter 1 to select a new piece, or 2 to try another move: '
      user_input = @chessgame_input.player_input(1, 2)

      if user_input == 1
        puts 'Select a new piece: '
        player_piece = @chessgame_input.player_piece_input(@game_state[:current_turn], @chess_board)
        puts 'Enter a move:'
      else
        puts 'Enter a new move'
      end
      new_pos = @chessgame_input.player_move_input
    end
  end

  def display
    gray_space = '|#'
    white_space = '|_'

    unless @chess_board.nil?
      7.step(0, -1) do |y|
        print "#{y + 1} "
        8.times do |x|
          node = @chess_board.find_node([x, y])

          if !node.piece.nil?
            print "|#{node.piece.unicode}"
          elsif node.coor[1].even?
            if node.coor[0].even?
              print gray_space
            else
              print white_space
            end
          elsif node.coor[1].odd?
            if node.coor[0].odd?
              print gray_space
            else
              print white_space
            end
          end
        end
        puts '|'
      end
      puts '   a b c d e f g h'
    end
  end

  def hypothetically_in_check?(new_pos, player_piece)
    result = false
    current_pos = player_piece.pos
    new_pos_node = @chess_board.find_node(new_pos)
    new_pos_piece = new_pos_node.piece
    move(new_pos, player_piece)

    if player_piece.instance_of?(King)
      result = true if player_piece.in_check?(@chess_board) || can_enemy_king_check?
    else
      result = true if player_king_in_check?
    end

    move(current_pos, player_piece)
    new_pos_node.piece = new_pos_piece

    result
  end

  def can_promote_pawn?(new_pos, player_piece)
    return true if player_piece.color == 'white' && new_pos[1] == 7 && player_piece.instance_of?(Pawn)
    return true if player_piece.color == 'black' && (new_pos[1]).zero? && player_piece.instance_of?(Pawn)

    false
  end

  def promote_pawn(player_piece)
    if @game_state[:current_turn] == 'black'
      player_piece = [Queen, Rook, Bishop, Knight].sample.new(player_pos.pos, 'black')
    else
      puts 'Select a piece to promote to - '
      puts 'Enter 1 for queen, 2 for bishop, 3 for knight, 4 for rook: '
      user_input = @chessgame_input.player_input(1, 4)

      case user_input
      when 1
        player_piece = Queen.new(player_piece.pos, 'white')
      when 2
        player_piece = Bishop.new(player_piece.pos, 'white')
      when 3
        player_piece = Knight.new(player_piece.pos, 'white')
      when 4
        player_piece = Rook.new(player_piece.pos, 'white')
      end
    end 
    player_piece
  end

  def set_checkmate
    king_pieces = @chess_board.board.filter { |node| !node.piece.nil? && node.piece.instance_of?(King) }
    king_pieces.collect!(&:piece)
    checked_king = king_pieces.find { |king| king.in_check?(@chess_board) }
    return if checked_king.nil?

    pieces_with_moves = []

    get_friendly_pieces.each do |piece|
      moves = piece.possible_moves(@chess_board).filter { |node| !hypothetically_in_check?(node.coor, piece) }
      pieces_with_moves << [piece, moves] unless moves.empty?
    end

    if pieces_with_moves.empty?
      @game_state[:mate] = checked_king.color
      checked_king
    end

  end

  def set_stalemate
    player_pieces = get_friendly_pieces

    if player_pieces.all? do |piece|
      piece.possible_moves(@chess_board).all? do |node|
        hypothetically_in_check?(node.coor, piece)
      end
    end
      @game_state[:stalemate] = true
      player_pieces
    end
  end

  def game_over?
    return true if @game_state[:draw] || !@game_state[:resign].nil? || !set_checkmate.nil? || !set_stalemate.nil?

    false
  end

  # returns true if the enemy king could check the player king
  def can_enemy_king_check?
    friendly_king = get_friendly_pieces.find { |piece| piece.instance_of?(King) }
    enemy_king = @chess_board.board.find do |node|
      !node.piece.nil? && node.piece.instance_of?(King) && node.piece.color != @game_state[:current_turn]
    end
    enemy_king = enemy_king.piece

    enemy_king.possible_moves(@chess_board).each do |node|
      return true if node.coor == friendly_king.pos
    end
    
    false
  end

  private

  def make_computer_move
    computer_move = @computer.generate_move
    new_pos = computer_move[1].coor
    player_piece = computer_move[0]

    pawn_move_actions(new_pos, player_piece) if player_piece.instance_of?(Pawn)
    castle(new_pos, player_piece) if player_piece.instance_of?(King)

    tep_pawn = find_pawn_tep
    tep_pawn.t_e_p = false unless tep_pawn.nil?
    log_move(new_pos, player_piece)
    move(new_pos, player_piece)
    player_piece.has_moved = true

    return new_pos
  end

  def castle(new_pos, player_piece)
    # short castling
    if (new_pos[0] - player_piece.pos[0]).abs == 2 && new_pos[0] > player_piece.pos[0]
      castling_rook = @chess_board.find_node([7, 0]).piece if player_piece.color == 'white'
      castling_rook = @chess_board.find_node([7, 7]).piece if player_piece.color == 'black'
      move([new_pos[0] - 1, new_pos[1]], castling_rook)
    elsif (new_pos[0] - player_piece.pos[0]).abs == 2 && new_pos[0] < player_piece.pos[0]
      # long castling
      castling_rook = @chess_board.find_node([0, 0]).piece if player_piece.color == 'white'
      castling_rook = @chess_board.find_node([0, 7]).piece if player_piece.color == 'black'
      move([new_pos[0] + 1, new_pos[1]], castling_rook)
    end
    
  end

  def pawn_move_actions(new_pos, player_piece)
    player_piece.set_take_en_passant(new_pos, @chess_board)
    player_piece.take_en_passant(new_pos, @chess_board) if player_piece.t_e_p
    player_piece = promote_pawn(player_piece) if can_promote_pawn?(new_pos, player_piece)
  end

  def get_friendly_pieces
    nodes = @chess_board.board.filter { |node| !node.piece.nil? && node.piece.color == @game_state[:current_turn] }
    nodes.collect(&:piece)
  end

  def log_move(new_pos, player_piece)
    str_old_pos = @@BOARD_RANK[player_piece.pos[0]] + @@BOARD_FILE[player_piece.pos[1]]
    str_new_pos = @@BOARD_RANK[new_pos[0]] + @@BOARD_FILE[new_pos[1]]

    @game_state[:move_history] << "#{player_piece.color}: #{player_piece.class} #{str_old_pos} to #{str_new_pos}"
  end

  def get_menu_choice
    loop do
      puts '1: Select a new piece '
      puts '2: Enter a move '
      puts '3: Save Game '
      puts '4: View move history '
      puts '5: Resign Game '
      puts '6: Quit '

      user_input = @chessgame_input.player_input(1, 6)

      case user_input
      when 1
        return 1
      when 2
        return 2
      when 3
        save_game
        puts 'Game saved!'
        next
      when 4
        unless @game_state[:move_history].empty?
          puts "\t\t\t\tMove History:\n"
          puts "\t\t\t\t----------------"
          @game_state[:move_history].reverse_each { |move| puts "\t\t\t\t#{move}" }
        end

        next
      when 5
        @game_state[:resign] = @game_state[:current_turn]
        return 5
      when 6
        puts 'Quitting...'
        exit
      end
    end
  end

  def move(new_pos, player_piece)
    @chess_board.find_node(new_pos).piece = player_piece
    @chess_board.find_node(player_piece.pos).piece = nil
    player_piece.pos = new_pos
  end

  def player_king_in_check?
    king = @chess_board.board.find do |node|
      node.piece.instance_of?(King) && node.piece.color == @game_state[:current_turn]
    end.piece

    king.in_check?(@chess_board)
  end

  def find_pawn_tep
    pawn_node = @chess_board.board.find do |node|
      node.piece.instance_of?(Pawn) && node.piece.color == @game_state[:current_turn] && node.piece.t_e_p
    end
    return pawn_node.piece if pawn_node
  end

  def game_over_message
    draw_message = 'Draw!'
    resign_message = "#{@game_state[:resign]} resigns!"
    checkmate_message = "#{@game_state[:mate]} is checkmated!"
    stalemate_message = 'Stalemate! Game is a draw.'

    if @game_state[:draw]
      draw_message
    elsif @game_state[:resign]
      resign_message
    elsif @game_state[:mate]
      checkmate_message
    elsif @game_state[:stalemate]
      stalemate_message
    end
  end

  def set_board
    @chess_board.board.each do |node|
      if node.coor == [0, 0]
        node.piece = Rook.new([0, 0], 'white')
      elsif node.coor == [1, 0]
        node.piece = Knight.new([1, 0], 'white')
      elsif node.coor == [2, 0]
        node.piece = Bishop.new([2, 0], 'white')
      elsif node.coor == [3, 0]
        node.piece = Queen.new([3, 0], 'white')
      elsif node.coor == [4, 0]
        node.piece = King.new([4, 0], 'white')
      elsif node.coor == [5, 0]
        node.piece = Bishop.new([5, 0], 'white')
      elsif node.coor == [6, 0]
        node.piece = Knight.new([6, 0], 'white')
      elsif node.coor == [7, 0]
        node.piece = Rook.new([7, 0], 'white')
      elsif node.coor[1] == 1
        node.piece = Pawn.new(node.coor, 'white')

      elsif node.coor[1] == 6
        node.piece = Pawn.new(node.coor, 'black')
      elsif node.coor == [0, 7]
        node.piece = Rook.new([0, 7], 'black')
      elsif node.coor == [1, 7]
        node.piece = Knight.new([1, 7], 'black')
      elsif node.coor == [2, 7]
        node.piece = Bishop.new([2, 7], 'black')
      elsif node.coor == [3, 7]
        node.piece = Queen.new([3, 7], 'black')
      elsif node.coor == [4, 7]
        node.piece = King.new([4, 7], 'black')
      elsif node.coor == [5, 7]
        node.piece = Bishop.new([5, 7], 'black')
      elsif node.coor == [6, 7]
        node.piece = Knight.new([6, 7], 'black')
      elsif node.coor == [7, 7]
        node.piece = Rook.new([7, 7], 'black')
      end
    end
  end

  def save_game
    require 'yaml'

    File.open('lib/chessgame_save.yaml', 'w') do |file|
      file.write YAML.dump(@game_state)
      file.write YAML.dump(@chess_board)
    end
  end

  def load_game
    require 'yaml'

    if File.zero?('lib/chessgame_save.yaml')
      nil
    else
      f = File.open('lib/chessgame_save.yaml')
      objects = YAML.load_stream(f)
      f.close

      @game_state = objects[0]
      @chess_board = objects[1]
    end
  end
end

c = ChessGame.new
# chess_board = c.instance_variable_get(:@chess_board)
# game_state = c.instance_variable_get(:@game_state)
# game_state[:current_turn] = 'black'
# player_king  = King.new([7, 7], 'black')
# enemy_king = King.new([7, 5], 'white')
# enemy_rook = Rook.new([6, 5], 'white')
# chess_board.find_node([7, 5]).piece = enemy_king
# chess_board.find_node([6, 5]).piece = enemy_rook
# chess_board.find_node([7, 7]).piece = player_king

c.play_game

# c.load_game
# c.display

# node = c.chess_board.find_node([3,3])
# node.piece = Rook.new(node.coor, 'black')
# c.display
# c.save_game
