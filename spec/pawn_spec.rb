# frozen_string_literal: true

require_relative '../lib/pawn'
require_relative '../lib/chesspiece'
require_relative '../lib/board'

describe Pawn do
  let(:chess_board) { Board.new }

  describe '#valid_move?' do
    subject(:black_pawn_move) { described_class.new([3, 6], 'black') }
    subject(:white_pawn_move) { described_class.new([3, 1], 'white') }

    context 'if pawn attempts to move backwards' do
      it 'returns false' do
        new_pos = [3, 7]

        expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be false
      end

      it 'works with white pawns' do
        new_pos = [3, 0]

        expect(white_pawn_move.valid_move?(new_pos, chess_board)).to be false
      end
    end

    context 'when new_pos is moving pawn vertically by more than two spaces' do
      it 'returns false' do
        new_pos = [3, 3]

        expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be false
      end

      it 'works with white pawn' do
        new_pos = [3, 4]

        expect(white_pawn_move.valid_move?(new_pos, chess_board)).to be false
      end
    end

    context 'when new_pos is moving pawn horizontally by more than one spaces' do
      it 'returns false' do
        new_pos = [5, 6]

        expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be false
      end

      it 'works with white pawn' do
        new_pos = [0, 1]

        expect(white_pawn_move.valid_move?(new_pos, chess_board)).to be false
      end
    end

    context 'when the pawn moves up two spaces' do
      context 'if the pawn has already moved in the game' do
        subject(:moved_black_pawn) { described_class.new([3, 5], 'black') }
        subject(:moved_white_pawn) { described_class.new([3, 2], 'black') }

        before do
          moved_white_pawn.has_moved = true
          moved_black_pawn.has_moved = true
        end

        it 'returns false' do
          new_pos = [3, 3]

          expect(moved_black_pawn.valid_move?(new_pos, chess_board)).to be false
        end

        it 'works with white pawns' do
          new_pos = [3, 4]

          expect(moved_white_pawn.valid_move?(new_pos, chess_board)).to be false
        end
      end

      context 'if there is a piece in the way' do
        let(:chess_piece) { ChessPiece.new }
        let(:chess_piece2) { ChessPiece.new }
        before do
          black_path_node = chess_board.find_node([3, 5])
          black_path_node.piece = chess_piece

          white_path_node = chess_board.find_node([3, 2])
          white_path_node.piece = chess_piece2
        end

        it 'returns false' do
          new_pos = [3, 4]

          expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be false
        end

        it 'works with white pawns' do
          new_pos = [3, 3]

          expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be false
        end
      end

      context 'when pawn has not moved yet and there is no piece in the way' do
        it 'returns true' do
          new_pos = [3, 4]

          expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be true
        end

        it 'works with white pawns' do
          new_pos = [3, 3]

          expect(white_pawn_move.valid_move?(new_pos, chess_board)).to be true
        end
      end
    end

    context 'if pawn horizontal position goes up by 1' do
      context 'if the move is not diagonal' do
        it 'returns false' do
          new_pos = [4, 6]

          expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be false
        end

        it 'works with white pawns ' do
          new_pos = [4, 1]

          expect(white_pawn_move.valid_move?(new_pos, chess_board)).to be false
        end
      end

      context 'if move is diagonal' do
        context 'when there is no enemy piece on the new_pos space' do
          context 'when pawn can not take en passant' do
            it 'returns false' do
              new_pos = [2, 5]

              expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be false
            end
          end

          context 'when pawn can take en passant and there is pawn on above the new_pos to take' do

            before do
              black_pawn_move.t_e_p = true
              black_pawn_move.pos = [3, 3]
              chess_board.find_node([3, 3]).piece = black_pawn_move
            end
            
            it 'returns false' do
              new_pos = [4, 2]

              expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be false
            end
          end

          context 'when the pawn can take en passant and there is a pawn above the new_pos to take' do
            before do
              black_pawn_move.t_e_p = true
              black_pawn_move.pos = [3, 3]
              chess_board.find_node([3, 3]).piece = black_pawn_move
              chess_board.find_node([4, 2]).piece = nil
              chess_board.find_node([4, 3]).piece = Pawn.new([4, 3], 'white')
            end

            it 'returns true' do
              new_pos = [4, 2]
              chess_board.board.each do |node|
                puts "#{node.coor}: #{node.piece.color if node.piece}"
              end
              expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be true
            end
          end

          context 'when there is an enemy piece on the new_pos space' do
            let(:enemy_piece) { ChessPiece.new }
            let(:enemy_piece2) { ChessPiece.new }
            before do
              black_new_pos_node = chess_board.find_node([4, 5])
              black_new_pos_node.piece = enemy_piece

              white_new_pos_node = chess_board.find_node([2, 2])
              white_new_pos_node.piece = enemy_piece2
            end

            it 'returns true' do
              new_pos = [4, 5]

              expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be true
            end

            it 'works with white pawns' do
              new_pos = [2, 2]

              expect(white_pawn_move.valid_move?(new_pos, chess_board)).to be true
            end
          end
        end
      end
    end
  end

  describe '#set_take_en_passant' do
    subject(:black_pawn_tep) { described_class.new([3, 3], 'black') }
    subject(:white_pawn_tep) { described_class.new([2, 1], 'white') }

    before do
      chess_board.find_node([3, 3]).piece = black_pawn_tep
      chess_board.find_node([2, 1]).piece = black_pawn_tep
    end

    context 'when player moves pawn up two from start' do
      context 'if the pawn lands next to an enemy pawn' do
        it 'sets enemy pawn t_e_p to true' do
          new_pos = [2, 3]

          expect { white_pawn_tep.set_take_en_passant(new_pos, chess_board) }.to change {
                                                                                   black_pawn_tep.t_e_p
                                                                                 }.from(false).to(true)
        end

        it 'works when moving pawn is black' do
          chess_board.find_node([3, 6]).piece = black_pawn_tep
          black_pawn_tep.pos = [3, 6]

          chess_board.find_node([2, 4]).piece = white_pawn_tep
          white_pawn_tep.pos = [2, 4]
          new_pos = [3, 4]

          expect { black_pawn_tep.set_take_en_passant(new_pos, chess_board) }.to change {
                                                                                   white_pawn_tep.t_e_p
                                                                                 }.from(false).to(true)
        end
      end
    end
  end

  describe '#take_en_passant' do
    subject(:black_pawn_tep) { described_class.new([3, 3], 'black') }
    subject(:white_pawn_tep) { described_class.new([2, 3], 'white') }

    context 'when attacking black pawn takes white pawn en passant' do
      before do
        chess_board.find_node(black_pawn_tep.pos).piece = black_pawn_tep
        chess_board.find_node(white_pawn_tep.pos).piece = white_pawn_tep
        black_pawn_tep.t_e_p = true
      end

      it 'removes the white pawn from the node' do
        new_pos = [white_pawn_tep.pos[0], white_pawn_tep.pos[1] - 1]
        taken_pawn_node = chess_board.find_node(white_pawn_tep.pos)

        expect { black_pawn_tep.take_en_passant(new_pos, chess_board) }.to change {
                                                                             taken_pawn_node.piece
                                                                           }.from(white_pawn_tep).to(nil)
      end

      it 'returns new_pos' do
        new_pos = [white_pawn_tep.pos[0], white_pawn_tep.pos[1] - 1]

        expect(black_pawn_tep.take_en_passant(new_pos, chess_board)).to eq(new_pos)
      end

      it 'sets the attacking pawn T_E_P to false' do
        new_pos = [white_pawn_tep.pos[0], white_pawn_tep.pos[1] - 1]

        expect { black_pawn_tep.take_en_passant(new_pos, chess_board) }.to change {
                                                                             black_pawn_tep.t_e_p
                                                                           }.from(true).to(false)
      end
    end
    context 'when attacking white pawn takes black pawn en passant' do
      before do
        black_pawn_tep.pos = [4, 4]
        white_pawn_tep.pos = [3, 4]

        chess_board.find_node(black_pawn_tep.pos).piece = black_pawn_tep
        chess_board.find_node(white_pawn_tep.pos).piece = white_pawn_tep
        white_pawn_tep.t_e_p = true
      end

      it 'removes the white pawn from the node' do
        new_pos = [black_pawn_tep.pos[0], black_pawn_tep.pos[1] + 1]
        taken_pawn_node = chess_board.find_node(black_pawn_tep.pos)

        expect { white_pawn_tep.take_en_passant(new_pos, chess_board) }.to change {
                                                                             taken_pawn_node.piece
                                                                           }.from(black_pawn_tep).to(nil)
      end

      it 'returns new_pos' do
        new_pos = [black_pawn_tep.pos[0], black_pawn_tep.pos[1] + 1]

        expect(white_pawn_tep.take_en_passant(new_pos, chess_board)).to eq(new_pos)
      end

      it 'sets the attacking pawn T_E_P to false' do
        new_pos = [black_pawn_tep.pos[0], black_pawn_tep.pos[1] + 1]

        expect { white_pawn_tep.take_en_passant(new_pos, chess_board) }.to change {
                                                                             white_pawn_tep.t_e_p
                                                                           }.from(true).to(false)
      end
    end
  end
end
