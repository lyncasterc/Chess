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

    context 'when line formed by end and start positions is horizontal or vertical' do
      it 'returns true' do
        start_pos = [3,3]
        end_pos = [3,6]

        expect(linear_board.horizontal_or_vertical?(start_pos, end_pos)).to be true
      end

      it 'works with other horizontal or vertical paths' do
        start_pos = [3,3]
        end_pos = [7,3]

        expect(linear_board.horizontal_or_vertical?(start_pos, end_pos)).to be true
      end
    end

    context 'when line formed by end and start positions is not horizontal or vertical' do
      it 'returns false' do
        start_pos = [3,3]
        end_pos = [4,2]

        expect(linear_board.horizontal_or_vertical?(start_pos, end_pos)).to be false
      end

      it 'works with other non-horizontal or non-vertical paths' do
        start_pos = [3,3]
        end_pos = [0,6]

        expect(linear_board.horizontal_or_vertical?(start_pos, end_pos)).to be false
      end
    end
  end
  describe '#get_linear_path' do
    subject(:linear_board) { described_class.new }

    context 'when passed two positions that are horizontal or vertical' do
      it 'returns a non-empty array' do
        start_pos = [3,3]
        end_pos = [7,3]
        result = linear_board.get_linear_path(start_pos, end_pos)

        expect(result).to_not be_empty
      end

      it 'returns array only with nodes between but not equal to start_pos and end_pos' do
        start_pos = [3,3]
        end_pos = [7,3]
        result = linear_board.get_linear_path(start_pos, end_pos)

        expect(result.any? { |node| node.coor == start_pos || node.coor == end_pos }).to be false
      end

      it 'returns array of the expected length' do
        start_pos = [3,3]
        end_pos = [3,0]
        result = linear_board.get_linear_path(start_pos, end_pos)

        expect(result.length).to eq(2)
      end
    end
  end
  describe '#diagonal?' do
    subject(:diagonal_board) { described_class.new }

    context 'when line formed by end and start positions is diagonal' do
      it 'returns true' do
        start_pos = [3,3]
        end_pos = [5,5]

        expect(diagonal_board.diagonal?(start_pos, end_pos)).to be true
      end
      it 'works with other diagonal positions' do
        start_pos = [6,1]
        end_pos = [2,4]

        expect(diagonal_board.diagonal?(start_pos, end_pos)).to be true
      end
    end
    context 'when line formed by end and start positions is not diagonal' do
      it 'returns false' do
        start_pos = [3,3]
        end_pos = [4,3]

        expect(diagonal_board.diagonal?(start_pos, end_pos)).to be false
      end
      it 'works with other diagonal positions' do
        start_pos = [6,1]
        end_pos = [3,1]

        expect(diagonal_board.diagonal?(start_pos, end_pos)).to be false
      end
    end
  end
  describe '#get_diagonal_path' do
    subject(:diagonal_board) { described_class.new }

    context 'when passed two positions that are diagonal' do
      it 'returns a non-empty array' do
        start_pos = [3,3]
        end_pos = [7,7]
        result = diagonal_board.get_diagonal_path(start_pos, end_pos)

        expect(result).to_not be_empty
      end

      it 'returns array only with nodes between but not equal to start_pos and end_pos' do
        start_pos = [3,3]
        end_pos = [7,7]
        result = diagonal_board.get_diagonal_path(start_pos, end_pos)

        expect(result.any? { |node| node.coor == start_pos || node.coor == end_pos }).to be false
      end

      it 'returns array of the expected length' do
        start_pos = [3,3]
        end_pos = [6,0]
        result = diagonal_board.get_diagonal_path(start_pos, end_pos)

        expect(result.length).to eq(2)
      end
    end
  end

end
