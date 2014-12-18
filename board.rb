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

  def [] pos
    grid[pos[0]][pos[1]]
  end

  def []= pos, piece
    grid[pos[0]][pos[1]] = piece
  end

  def display_board
    bg = [:light_white, :black]
    colors = {:black => :light_blue, :red => :red}
    puts '\  0  1  2  3  4  5  6  7'
    grid.each_with_index do |row, i|
      print i, ' '
      row.each_with_index do |piece, j|
        color = ((i + j) % 2)
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

b = Board.new
b.setup_board
b.display_board
