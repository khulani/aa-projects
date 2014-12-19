require 'colorize'

class MoveError < StandardError
end

class Piece
  DELTAS = [ [1, -1], [2, -2], [1, 1], [2, 2],
             [-1, -1], [-2, -2], [-1, 1], [-2, 2] ]
  DIR = { :red => [0, 3], :black => [4, 7], :king =>[0,7] }
  MID = { -2 => -1, 2 => 1 }

  attr_accessor :pos, :type, :color, :board, :direction

  def initialize position, type, color, board
    @pos = position
    @type = :pawn
    @color = color
    @board = board
  end

  def check_move there
    unless (0..7).include?(there[0]) || (0..7).include?(there[1])
      raise MoveError.new "Not on board"
    end
    raise MoveError.new "Square not empty." unless board[there].nil?

    deltas = []
    delta = [there[0] - pos[0], there[1] - pos[1]]
    if type == :king
      deltas = DELTAS
    else
      deltas = DELTAS[DIR[color][0]..DIR[color][1]]
    end

    raise MoveError.new "Move out of range." unless deltas.include? delta
  end

  def make_king
    if (color == :black && pos[0] == 0) || (color == :white && pos[0] == 7)
      self.type = :king
    end
  end

  def update_pos there
    board[pos] = nil
    self.pos = there
    board[pos] = self
    make_king
  end

  def jump_available?
    range = DIR[color]
    range = DIR[:king] if type == :king

    (range[0]..range[1]).step(2) do |i|
      mid = board[[pos[0] + DELTAS[i][0], pos[1] + DELTAS[i][1]]]
      land = board[[pos[0] + DELTAS[i + 1][0], pos[0] + DELTAS[i + 1][1]]]
      return true unless mid.nil? || land.nil? || mid.color == color
    end

    false
  end

  def perform_jump there
    check_move there

    mid_x = MID[there[0] - pos[0]] + pos[0]
    mid_y = MID[there[1] - pos[1]] + pos[1]
    mid = [mid_x, mid_y]

    jumpee = board[mid]
    raise MoveError.new "Invalid Jump." if jumpee.nil? || jumpee.color == color

    board[mid] = nil
    update_pos there
  end

  def perform_slide there
    check_move there
    update_pos there
  end

  # def move there
  #   if (there[0] - pos[0]).abs == 1
  #     perform_slide there
  #   else
  #     perform_jump there
  #   end
  # end

  def display
    type == :pawn ? "\u2727" : "\u272A" # ✧ / ✪ - Ⓞ Ⓚ ⓵
  end

end
