require_relative '../lib/board'
require_relative '../lib/node'

describe Board do
  describe '#off_board?' do
    subject(:board) { described_class.new }

    context 'when position is off the board' do
      it 'returns true' do
        pos = [8,3]
        
        expect(board.off_board?(pos)).to be true
      end

      it 'works with other off-board positions' do
        pos = [3,8]
        
        expect(board.off_board?(pos)).to be true
      end
    end

    context 'when pos is on the board' do
      it 'returns true' do
        pos = [7,3]
        
        expect(board.off_board?(pos)).to be false
      end

      it 'works with other on-board positions' do
        pos = [3,7]
        
        expect(board.off_board?(pos)).to be false
      end
    end
  end
end
