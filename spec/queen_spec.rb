require_relative '../lib/queen'
require_relative '../lib/gamepiece'
require_relative '../lib/board'

describe Queen do
  let(:chess_board) { Board.new }

  describe '#valid_move?' do
    subject(:queen_move) { described_class.new([3,3], 'white') }

    context 'when new_pos is not horizontal/vertical or diagonal' do
      it 'returns false' do
        new_pos = [4,5]

        expect(queen_move.valid_move?(new_pos, chess_board)).to be false
      end
    end

    context 'when new_pos is horizontal/vertical and valid' do
      it 'returns true' do
        new_pos = [3,5]

        expect(queen_move.valid_move?(new_pos, chess_board)).to be true        
      end

      it 'works with other valid horizontal/vertical moves' do
        new_pos = [2,3]

        expect(queen_move.valid_move?(new_pos, chess_board)).to be true 
      end
    end

    context 'when new_pos is diagonal and valid' do
      it 'returns true' do
        new_pos = [1,1]

        expect(queen_move.valid_move?(new_pos, chess_board)).to be true 
      end

      it 'works with other diagonal moves' do
        new_pos = [4,2]

        expect(queen_move.valid_move?(new_pos, chess_board)).to be true
      end
    end
  end
end