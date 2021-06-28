require_relative '../lib/king'
require_relative '../lib/rook'
require_relative '../lib/gamepiece'
require_relative '../lib/board'


describe King do
  let(:chess_board) { Board.new }

  describe '#valid_move?' do
    subject(:white_king_move) { described_class.new([3,3],'white')}

    context 'when player attempts to move king vertically by more than one space' do
      it 'returns false' do 
        new_pos = [3,5]

        expect(white_king_move.valid_move?(new_pos, chess_board)).to be false
      end
    end

    context 'when the player attempts to move king horizontally by more than 2 spaces' do
      it 'returns false ' do
        new_pos = [6,3]

        expect(white_king_move.valid_move?(new_pos, chess_board)).to be false
      end
    end

    context 'when the player attempts to move king horizontally exactly two spaces' do
      context 'if the king can not castle' do
        before do
          white_king_move.has_moved = true
        end
        it 'returns false' do
          new_pos = [5,3] 

          expect(white_king_move.valid_move?(new_pos, chess_board)).to be false
        end
      end
    end

    context 'when player attempts to move king on position that is being attacked' do
      let(:enemy_piece) { Rook.new([4,1], 'black') }

      before do
        enemy_node = chess_board.find_node([4,1])
        enemy_node.piece = enemy_piece
      end

      it 'returns false' do
        new_pos = [4,3]

        expect(white_king_move.valid_move?(new_pos, chess_board)).to be false
      end
    end

    context 'when the player makes a valid king move' do
      it 'returns true' do
        new_pos = [4,3]

        expect(white_king_move.valid_move?(new_pos,chess_board)).to be true
      end
    end
  end

  describe '#can_castle?' do
    subject(:white_king_castle) { described_class.new([4,0],'white')}
    subject(:black_king_castle) { described_class.new([4,7],'black')}

    let(:black_rook_1) { Rook.new([7,7], 'black') }
    let(:black_rook_2) { Rook.new([0,7], 'black') }
    let(:white_rook_1) { Rook.new([7,0], 'white') }
    let(:white_rook_2) { Rook.new([0,0], 'white') }

    before do
      chess_board.board.each do |node|

        if node.coor == [0,0]
          node.piece = white_rook_2
        elsif node.coor == [7,0]
          node.piece = white_rook_1
        elsif node.coor == [0,7]
          node.piece = black_rook_2
        elsif node.coor == [7,7]
          node.piece = black_rook_1
        end

      end
    end
    
    context 'return false if castling rook has moved' do

      before do
        black_rook_1.has_moved = true 
      end

      it 'returns false ' do
        castle_pos = [6,7]

        expect(black_king_castle.can_castle?(chess_board, castle_pos)).to be false
      end

    end

  end
end