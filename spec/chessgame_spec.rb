require_relative '../lib/chessgame.rb'
require_relative '../lib/chessgame_input.rb'

describe ChessGame do
  subject(:game_move) { described_class.new }
  let(:chess_board) { game_move.instance_variable_get(:@chess_board) }
  
  describe '#move' do
    let(:player_piece) { chess_board.find_node([2,1]).piece }
    
    context 'when the move is valid' do
      before do
        game_move.send(:set_board)
      end

      it 'returns the new_pos' do
        new_pos = [2,2]
        expect(game_move.move(new_pos, player_piece)).to eq(new_pos)
      end

      it 'does not output error message' do
        new_pos = [2,2]
        error_message = "Input error! This move is not valid."

        expect(game_move).not_to receive(:puts).with(error_message)
        game_move.move(new_pos, player_piece)
      end

      it 'moves the player piece to the new_pos node' do
        new_pos = [2,2]
        new_pos_node = chess_board.find_node(new_pos)

        expect{ game_move.move(new_pos, player_piece) }.to change { new_pos_node.piece }.from(nil).to(player_piece)
      end

      it 'changes the player_piece pos instance variable to new_pos' do
        new_pos = [2,2]

        expect { game_move.move(new_pos, player_piece) }.to change { player_piece.pos }.from([2,1]).to(new_pos)
      end

      it 'changes the old node pos instance variable to nil' do
        new_pos = [2,2]
        old_pos_node = chess_board.find_node(player_piece.pos)

        expect{ game_move.move(new_pos, player_piece) }.to change { old_pos_node.piece }.from(player_piece).to(nil)
      end

      context 'when the player piece is a pawn' do 
        it 'changes the has_moved instance variable to true' do
          new_pos = [2,3]

          expect { game_move.move(new_pos, player_piece) }.to change { player_piece.has_moved }.from(false).to(true)
        end
      end

      context 'if a friendly pawn has t_e_p set to true' do
        let(:friendly_pawn) { chess_board.find_node([3,1]).piece }

        before do
          friendly_pawn.t_e_p = true
        end
    
        it 'sets the pawn t_e_p to false' do
          new_pos = [2,3]
          
          expect { game_move.move(new_pos, player_piece) }.to change { friendly_pawn.t_e_p }.from(true).to(false)
        end
      end

      context 'when the player piece is a rook' do 
        let(:rook_player_piece) { chess_board.find_node([0,0]).piece }

        before do
          chess_board.find_node([0,1]).piece = nil
        end

        it 'changes the has_moved instance variable to true' do
          new_pos = [0,4]

          expect { game_move.move(new_pos,rook_player_piece) }.to change { rook_player_piece.has_moved }.from(false).to(true)
        end
      end

      context 'when the player piece is a king' do 
        let(:king_player_piece) { chess_board.find_node([4,0]).piece }

        before do
          chess_board.find_node([4,1]).piece = nil
        end

        it 'changes the has_moved instance variable to true' do
          new_pos = [4,1]

          expect { game_move.move(new_pos, king_player_piece ) }.to change { king_player_piece.has_moved }.from(false).to(true)
        end
      end    
    end

    
  end

  describe '#hypothetically_in_check?' do
    context 'when a new_pos would leave a the current player king in check' do
      let(:player_piece) { chess_board.find_node([3,0]).piece }

      before do
        game_move.send(:set_board)
        enemy_queen = chess_board.find_node([3,7]).piece
        chess_board.find_node([4,2]).piece = player_piece
        player_piece.pos = [4,2]
        chess_board.find_node([4,5]).piece = enemy_queen
        enemy_queen.pos = [4,5]
        chess_board.find_node([4,1]).piece = nil
      end

      it 'returns true' do
        new_pos = [5,3]

        expect(game_move.hypothetically_in_check?(new_pos, player_piece)).to be true 
      end

      it 'does not change the player_piece pos' do
        new_pos = [5,3]

        expect{ game_move.hypothetically_in_check?(new_pos, player_piece) }.not_to change { player_piece.pos }
      end

      it 'does not change the original board object' do
        new_pos = [5,3]

        expect{ game_move.hypothetically_in_check?(new_pos, player_piece) }.not_to change { chess_board }
      end

    end
  end
end