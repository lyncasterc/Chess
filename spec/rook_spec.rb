require_relative '../lib/rook'
require_relative '../lib/gamepiece'
require_relative '../lib/board'

describe Rook do
  let(:chess_board) { Board.new }

  describe '#valid_move?' do
    subject(:rook_move) { described_class.new([3,3], 'white') }

    context 'when new_move[0] is off the board' do
      it 'returns false' do
        new_move = [8,3]
      
        expect(rook_move.valid_move?(new_move, chess_board)). to be false
      end
    end

    context 'when new_move[1] is off the board' do
      it 'returns false' do
        new_move = [3,8]
      
        expect(rook_move.valid_move?(new_move, chess_board)). to be false
      end
    end

    context 'when path from pos to new_move is not linear' do
      it 'returns false' do
        new_move = [4,4]
        expect(rook_move.valid_move?(new_move, chess_board)).to be false
      end
    end

    context 'when path from pos to new_move is linear' do
      it 'returns true' do
        new_move = [4,3]
        expect(rook_move.valid_move?(new_move, chess_board)).to be true
      end
    end

    it 'works with other linear paths' do 
      new_move = [3,6]
      expect(rook_move.valid_move?(new_move, chess_board)).to be true
    end

    context 'when a friendly piece is on the new_pos board node' do
      let(:friendly_rook) { described_class.new([7,3], 'white') }

      it 'returns false' do
        new_pos = [7,3]
        new_pos_node = chess_board.find_node(new_pos)
        new_pos_node.piece = friendly_rook

        expect(rook_move.valid_move?(new_pos, chess_board)).to be false 

      end
    end

    context 'when a enemy piece is on the new_pos board node' do
      let(:enemy_rook) { described_class.new([7,3], 'black') }

      it 'returns true' do
        new_pos = [7,3]
        new_pos_node = chess_board.find_node(new_pos)
        new_pos_node.piece = enemy_rook

        expect(rook_move.valid_move?(new_pos, chess_board)).to be true 

      end
    end
  end

end