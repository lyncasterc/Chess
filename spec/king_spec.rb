require_relative '../lib/king'
require_relative '../lib/gamepiece'
require_relative '../lib/board'

describe King do
  let(:chess_board) { Board.new }

  describe '#valid_move?' do
    subject(:king_move) { described_class.new([3,3],'white')}

    context 'when player attempts to move king vertically by more than one space' do
      it 'returns false' do 
        new_pos = [3,5]

        expect(king_move.valid_move?(new_pos, chess_board)).to be false
      end
    end
  end
end