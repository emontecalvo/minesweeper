require_relative 'board'
require_relative 'tile'

class Minesweeper

  attr_accessor :board

  def initialize
    @board = Board.new
  end

  def run
    until game_over?
      board.render
      if move?
        pos = get_move
        @board[pos].reveal
      else
        pos = get_move
        @board[pos].flag
      end
    end
    @board.render
    won? ? (puts "You won!") : (puts "BOOM! You Lose")

    puts "Game Over"
  end

  def move?
    move = false
    puts "input 1 to flag a space, input 0 to uncover a space"
    input = Integer(gets.chomp)
    move = true if input == 0
  end

  def won?
    @board.spaces_revealed?
  end

  def parse_input(input)
    input.split(",").map { |x| Integer(x) }
  end

  def get_move
    pos = nil

    until pos && valid_move?(pos)
      puts "What row, column would you like to explore?"
      puts "example:  0,0 for first row, first column"

      begin
        pos = parse_input(gets.chomp)
      rescue
        print "invalid move, must be in format 0,0"
        print "\n\n"
        get_move
      end
    end

    pos
  end

  def valid_move?(pos)
    pos.all? { |num| num < 9 && num >= 0 }
  end

  def game_over?
    @board.bombs_revealed? || @board.spaces_revealed?
  end

end

mine = Minesweeper.new
mine.run
