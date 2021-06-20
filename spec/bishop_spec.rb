require_relative '../lib/bishop'
require_relative '../lib/gamepiece'
require_relative '../lib/board'

describe Bishop do
  let(:chess_board) { Board.new }

  describe '#valid_move?' do
    subject(:bishop_move) { described_class.new([3,3], 'black') }

    context 'when path between pos and new_pos is not diagonal' do
      it 'returns false' do
        new_pos = [3,2]

        expect(bishop_move.valid_move?(new_pos, chess_board)).to be false
      end
    end

    context 'when a piece is between pos and new_pos path' do
      let(:path_piece) { GamePiece.new([4,2]) }
      it 'returns false' do
        new_pos = [6,0]
        path_node = chess_board.find_node([4,2])
        path_node.piece = path_piece
  
        expect(bishop_move.valid_move?(new_pos, chess_board)).to be false
      end
    end

    context 'when new_pos passes all conditions' do
      it 'returns true' do
        new_pos = [1,5]

        expect(bishop_move.valid_move?(new_pos, chess_board)).to be true
      end
    end
  end
end