require_relative 'board'

class Game
  attr_accessor :board, :cursor, :selected, :turns, :player, :message

  def initialize
    @board = Board.new
    board.setup_board
    @cursor = [0, 0]
    @selected = []
    @player = 'Player 1'
    @turns = { 'Player 1' => ['Player 2', :red],
      'Player 2' => ['Player 1', :black] }
    @message = nil
  end

  def display_game
    system('clear')
    board.display_board(cursor, selected)
    puts message unless message.nil?
  end

  def get_moves
    puts "#{player}, select move(s) using 'm' and press SPACEBAR..."
    keyboard = ''
    begin
      system("stty raw -echo")
      keyboard = STDIN.getc
    ensure
      system("stty -raw echo")
    end
    case keyboard
    when 'w'
      cursor[0] -= 1 if cursor[0] > 0
    when 's'
      cursor[0] += 1 if cursor[0] < 7
    when 'a'
      cursor[1] -= 1 if cursor[1] > 0
    when 'd'
      cursor[1] += 1 if cursor[1] < 7
    when 'm'
      if selected.include? cursor
        selected.delete cursor
      else
        selected << cursor.dup
      end
    when ' '
      board.run_move(selected, turns[player][1])
      self.player = turns[player][0]
      selected = []
      message = nil
    when 'q'
      exit
    end
  end

  def finish
    message = "#{turns[player]} wins! Game over."
    display_game
  end

  def run
    until board.over?
      begin
        display_game
        get_moves
      rescue MoveError => error
        self.message = error.message
        self.selected = []
        retry
      end
    end
    finish
  end

end

Game.new.run
