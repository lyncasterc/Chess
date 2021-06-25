require_relative '../lib/pawn'
require_relative '../lib/gamepiece'
require_relative '../lib/board'

describe Pawn do
  let(:chess_board) { Board.new }

  describe "#valid_move?" do
    subject(:black_pawn_move) { described_class.new([3,6],'black') }
    subject(:white_pawn_move) { described_class.new([3,1],'white') }

    context 'if pawn attempts to move backwards' do
      it 'returns false' do
        new_pos = [3,7]

        expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be false
      end

      it 'works with white pawns' do
        new_pos = [3,0]

        expect(white_pawn_move.valid_move?(new_pos, chess_board)).to be false
      end
    end

    context 'when new_pos is moving pawn vertically by more than two spaces' do
      it 'returns false' do 
        new_pos = [3,3]

        expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be false
      end

      it 'works with white pawn' do 
        new_pos = [3,4]

        expect(white_pawn_move.valid_move?(new_pos, chess_board)).to be false
      end
    end

    context 'when new_pos is moving pawn horizontally by more than one spaces' do
      it 'returns false' do 
        new_pos = [5,6]

        expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be false
      end

      it 'works with white pawn' do 
        new_pos = [0,1]

        expect(white_pawn_move.valid_move?(new_pos, chess_board)).to be false
      end
    end

    context 'when the pawn moves up two spaces' do
      context 'if the pawn has already moved in the game' do
        subject(:moved_black_pawn) { described_class.new([3,5], 'black') }
        subject(:moved_white_pawn) { described_class.new([3,2], 'black') }

        it 'returns false' do 
          new_pos = [3,3]

          expect(moved_black_pawn.valid_move?(new_pos, chess_board)).to be false
        end

        it 'works with white pawns' do
          new_pos = [3,4]

          expect(moved_white_pawn.valid_move?(new_pos, chess_board)).to be false
        end
      end

      context 'if there is a piece in the way' do
        let(:chess_piece) { GamePiece.new }
        let(:chess_piece2) { GamePiece.new }
        before do
          black_path_node = chess_board.find_node([3,5])
          black_path_node.piece = chess_piece

          white_path_node = chess_board.find_node([3,2])
          white_path_node.piece = chess_piece2
        end

        it 'returns false' do
          new_pos = [3,4]

          expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be false
        end

        it 'works with white pawns' do
          new_pos = [3,3]

          expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be false
        end
      end

      context 'when pawn has not moved yet and there is no piece in the way' do
        it 'returns true' do
          new_pos = [3,4]

          expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be true
        end

        it 'works with white pawns' do
          new_pos = [3,3]

          expect(white_pawn_move.valid_move?(new_pos, chess_board)).to be true
        end
      end
    end

    context 'if pawn horizontal position goes up by 1' do
      context 'if the move is not diagonal' do
        it 'returns false' do
          new_pos = [4,6]

          expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be false
        end

        it 'works with white pawns ' do
          new_pos = [4,1]

          expect(white_pawn_move.valid_move?(new_pos, chess_board)).to be false
        end
      end

      context 'if move is diagonal' do 
        context 'when there is no enemy piece on the new_pos space' do
          context 'when pawn can not take en passant' do
            it 'returns false' do
              new_pos = [2,5]
  
              expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be false
            end
          end

          context 'when pawn can take en passant' do
            before do
              black_pawn_move.t_e_p = true
              white_pawn_move.t_e_p = true
            end

            it 'returns true' do 
              new_pos = [2,5]

              expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be true
            end

            it 'works with white pawns' do 
              new_pos = [4,2]

              expect(white_pawn_move.valid_move?(new_pos, chess_board)).to be true
            end
          end
        end

        context 'when there is an enemy piece on the new_pos space' do
          let(:enemy_piece) { GamePiece.new }
          let(:enemy_piece2) { GamePiece.new }
          before do
            black_new_pos_node = chess_board.find_node([4,5])
            black_new_pos_node.piece = enemy_piece

            white_new_pos_node = chess_board.find_node([2,2])
            white_new_pos_node.piece = enemy_piece2
          end

          it 'returns true' do
            new_pos = [4,5]

            expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be true
          end

          it 'works with white pawns' do
            new_pos = [2,2]

            expect(white_pawn_move.valid_move?(new_pos, chess_board)).to be true
          end
        end
      end
    end
  end
end