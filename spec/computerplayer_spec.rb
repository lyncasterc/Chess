# frozen_string_literal: true

require_relative '../lib/king'
require_relative '../lib/rook'
require_relative '../lib/pawn'
require_relative '../lib/bishop'
require_relative '../lib/queen'
require_relative '../lib/knight'
require_relative '../lib/chesspiece'
require_relative '../lib/board'
require_relative '../lib/node'
require_relative '../lib/computerplayer'

describe ComputerPlayer do
  let(:chess_board) { Board.new }

  describe '#make_move' do
    subject(:computer_move) { ComputerPlayer.new(chess_board) }
    let(:computer_king) { King.new([4, 7], 'black') }

    context 'when a move is possible' do
      before do
        chess_board.find_node([3, 3]).piece = Bishop.new([3, 3], 'black')
        chess_board.find_node([4, 7]).piece = computer_king
      end

      it 'returns an array' do
        expect(computer_move.make_move).to be_an_instance_of(Array)
      end

      it 'returns a non-empty array' do
        expect(computer_move.make_move).not_to be_empty
      end

      it 'returns an array of 2 elements' do
        expect(computer_move.make_move.size).to eq(2)
      end

      it 'returns a black piece as the first element' do
        expect(computer_move.make_move.first.color).to eq('black')
      end

      it 'returns a valid move for the black piece as the second element' do
        move = computer_move.make_move
        piece = move[0]
        destination = move[1].coor

        expect(piece.valid_move?(destination, chess_board)).to be true
      end

      context 'when the computer is able to capture a piece' do
        let(:enemy_pawn) { Pawn.new([1, 1], 'white') }
        let(:enemy_knight) { Knight.new([6, 0], 'white') }

        before do
          chess_board.find_node([1, 1]).piece = enemy_pawn
        end

        it 'returns a capture move' do
          expect(computer_move.make_move.last.coor).to eq(enemy_pawn.pos)
        end

        context 'when the computer has one piece that can choose between two enemy pieces to capture' do
          before do
            chess_board.find_node([6, 0]).piece = enemy_knight
          end

          it 'captures the piece with the higher relative value' do
            expect(computer_move.make_move.last.coor).to eq(enemy_knight.pos)
          end
        end

        context 'when the computer has two pieces that can both capture an enemy piece' do
          let(:enemy_queen) { Queen.new([6, 1], 'white') }

          before do
            chess_board.find_node([5, 3]).piece = Knight.new([5, 3], 'black')
            chess_board.find_node([6, 1]).piece = enemy_queen
          end

          it 'returns the piece that can capture the enemy piece with highest relative value' do
            move = computer_move.make_move
            computer_piece = move[0]

            expect(computer_piece).to be_an_instance_of(Knight).and have_attributes(pos: [5, 3], color: 'black')
          end

          it 'captures the piece with the highest relative value' do
            expect(computer_move.make_move.last.coor).to eq(enemy_queen.pos)
          end
        end

      end

      context "when the computer's king is in check" do
        let(:enemy_rook) { Rook.new([4, 0], 'white') }

        before do
          chess_board.find_node([4, 0]).piece = enemy_rook
        end

        it 'returns a move that will not put the king in check' do
          move = computer_move.make_move
          piece = move[0]
          destination = move[1].coor
      
          expect(computer_move.send(:hypothetically_in_check?, destination, piece)).to be false
        end
      end
    end
  end
end
