require_relative '../lib/pawn'
require_relative '../lib/gamepiece'
require_relative '../lib/board'

describe Pawn do
  let(:chess_board) { Board.new }

  describe "#valid_move?" do
    subject(:black_pawn_move) { described_class.new([3,6],'black') }
    subject(:white_pawn_move) { described_class.new([3,1],'white') }

    context 'when black pawn new_pos is backwards from current position' do
      it 'returns false' do
        new_pos = [3,7]

        expect(black_pawn_move.valid_move?(new_pos, chess_board)).to be false
      end
    end
    context 'when white paws new_pos is backwards from current position' do
      it 'returns false' do
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
  end
end