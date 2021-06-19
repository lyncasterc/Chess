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
  describe '#is_linear' do
    subject(:linear_board) { described_class.new }

    context 'when line formed by end and start positions is linear' do
      it 'returns true' do
        start_pos = [3,3]
        end_pos = [3,6]

        expect(linear_board.is_linear?(start_pos, end_pos)).to be true
      end

      it 'works with other linear positions' do
        start_pos = [3,3]
        end_pos = [7,3]

        expect(linear_board.is_linear?(start_pos, end_pos)).to be true
      end
    end

    context 'when line formed by end and start positions is not linear' do
      it 'returns false' do
        start_pos = [3,3]
        end_pos = [4,2]

        expect(linear_board.is_linear?(start_pos, end_pos)).to be false
      end

      it 'works with other linear positions' do
        start_pos = [3,3]
        end_pos = [0,6]

        expect(linear_board.is_linear?(start_pos, end_pos)).to be false
      end
    end


  end
end
