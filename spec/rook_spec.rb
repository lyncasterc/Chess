require_relative '../lib/rook'
require_relative '../lib/gamepiece'

describe Rook do
  describe '#valid_move?' do
    subject(:rook_move) { described_class.new([3,3], 'white') }

    context 'when new_move[0] is off the board' do
      it 'returns false' do
        new_move = [8,3]
      
        expect(rook_move.valid_move?(new_move, board = nil)). to be false
      end
    end

    context 'when new_move[1] is off the board' do
      it 'returns false' do
        new_move = [3,8]
      
        expect(rook_move.valid_move?(new_move, board = nil)). to be false
      end
    end

    context 'when path from pos to new_move is not linear' do
      it 'returns false' do
        new_move = [4,4]
        expect(rook_move.valid_move?(new_move, board = nil)).to be false
      end
    end

    context 'when path from pos to new_move is linear' do
      it 'returns true' do
        new_move = [4,3]
        expect(rook_move.valid_move?(new_move, board = nil)).to be true
      end
    end
  end
end