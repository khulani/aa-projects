require 'colorize'

class Piece
  attr_accessor :square, :type, :color, :board

  def initialize position, type, color, board
    @pos = position
    @type = :pawn
    @color = color
    @board = board
  end

  def perform_jump there

  end

  def perform_slide there

  end

  def display
    type == :pawn ? "\u2727" : "\u272A" # ✧ / ✪ - Ⓞ Ⓚ ⓵
  end

end
