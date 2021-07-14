require_relative '../lib/knight'
require_relative '../lib/chesspiece'
require_relative '../lib/board'

describe Knight do
  let(:chess_board) { Board.new }

  describe '#valid_move?' do
    subject(:knight_move) { described_class.new([3,3],'white') }

    context 'when new_pos does not follow knight movement rules' do
      it 'returns false' do
        new_pos = [4,4]

        expect(knight_move.valid_move?(new_pos, chess_board)).to be false
      end
    end

    context 'when new_pos is valid' do
      it 'returns true' do
        new_pos = [2,5]

        expect(knight_move.valid_move?(new_pos, chess_board)).to be true
      end
    end
  end 
end