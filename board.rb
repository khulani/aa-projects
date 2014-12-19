require_relative 'piece'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def setup_board
    3.times do |row|
      (0..7).step(2) do |col|
        pos = [row, col + (row + 1) % 2]
        self[pos] = Piece.new(pos,:pawn, :red, self)
        pos = [7 - row, col + row % 2]
        self[pos] = Piece.new(pos,:pawn, :black, self)
      end
    end
  end

  def load_scenario
    self[[3,4]] = Piece.new([3,4],:pawn, :red, self)
    self[[4,3]] = Piece.new([4,3],:pawn, :black, self)
  end

  def over?
    pieces = grid.flatten.compact
    pieces.none? { |piece| piece.color == :red } ||
    pieces.none? { |piece| piece.color == :black }

    false
  end

  def jump_moves(color)
    pieces = grid.flatten.compact
    jumps = []
    pieces.each do |piece|
      jumps << piece.pos if piece.color == color && piece.jump_available?
    end

    jumps
  end

  def run_move(sequence, color)
    # p sequence
    # gets
    board_copy = self.dup
    jumps = jump_moves(color)
    if sequence.size < 2
      raise MoveError.new "Sequence incomplete."
    elsif self[sequence.first].nil?
      raise MoveError.new "Piece not selected"
    elsif self[sequence.first].color != color
      raise MoveError.new "Piece is not yours"
    elsif !jumps.empty? && !jumps.include?(sequence.first)
      raise MoveError.new "Must jump when available"
    elsif (sequence[1][0] - sequence[0][0]).abs == 1
      raise MoveError.new "Multiple moves for jumps only." if sequence.size > 2
      board_copy[sequence[0]].perform_slide sequence[1]
    else
      (1...sequence.size).each do |i|
        board_copy[sequence[i-1]].perform_jump sequence[i]
      end
      if board_copy[sequence.last].jump_available?
        raise MoveError.new "Must jump when possible."
      end
    end

    self.grid = board_copy.grid
  end

  def [] pos
    grid[pos[0]][pos[1]]
  end

  def []= pos, piece
    grid[pos[0]][pos[1]] = piece
  end

  def dup
    copy = self.class.new
    pieces = grid.flatten.compact
    pieces.each do |piece|
      copy[piece.pos] = piece.class.new(piece.pos, piece.type,
        piece.color, copy)
    end

    copy
  end

  def display_board (cursor, selected)
    print cursor, '-'
    p selected
    bg = [:light_white, :black, :yellow, :light_green]
    colors = {:black => :light_blue, :red => :red}
    puts '\  0  1  2  3  4  5  6  7'
    grid.each_with_index do |row, i|
      print i, ' '
      row.each_with_index do |piece, j|
        color = selected.include?([i,j]) ? 2 : (i + j) % 2
        color = 3 if cursor == [i,j]
        if piece.nil?
          print '   '.colorize(:background => bg[color])
        else
          print " #{piece.display} ".colorize(:color => colors[piece.color],
            :background => bg[color])
        end
      end
      puts
    end
  end

end



# ---- for testing purposes ----
#
# board = Board.new
# board.load_scenario
#
# loop do
#   begin
#     board.display_board([0, 0], [[1,2],[2,3]])
#     puts "Enter one move: "
#     a, b, x, y = gets.chomp.scan(/[\d]/).map(&:to_i)
#
#     board[[a, b]].move([x, y]) unless board[[a,b]].nil?
#   rescue MoveError => e
#     puts e.message
#     retry
#   rescue TypeError
#     retry
#   end
# end
