require_relative '../lib/bishop'
require_relative '../lib/gamepiece'
require_relative '../lib/board'

describe Bishop do
  let(:chess_board) { Board.new }

  describe '#valid_move?' do
    subject(:bishop_move) { described_class.new([3,3], 'black') }

    context 'when new_pos not diagonal' do
      it 'returns false' do
        new_pos = [3,2]

        expect(bishop_move.valid_move?(new_pos, chess_board)).to be false
      end
    end
  end
end