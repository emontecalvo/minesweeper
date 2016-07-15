require_relative "tile"
require 'colorize'

class Board
  attr_accessor :grid, :tile, :all_values

  def initialize
    @grid = Array.new(9) { Array.new(9) }
    @all_values = []
    populate_values
    create_tiles
    assign_bomb_warnings
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    tile = grid[x][y]
    tile.value = value
  end

  def render
    puts "   #{(0...@grid.count).to_a.join("  ")} "
    @grid.each_with_index do |row,idx|
      puts "#{idx}#{visual_row(row)}"
    end
  end

  def assign_bomb_warnings
    # assign number value if touching a bomb
    @grid.each_with_index do |row,i|
      row.each_with_index do |square,j|
        num_bombs = assign_value([i,j])
        @grid[i][j].value = num_bombs unless @grid[i][j].value == :B
      end
    end

  end

  def assign_value(pos)
    x, y = pos
    num_bombs = 0
    (x-1..x+1).to_a.each do |horz|
      (y-1..y+1).to_a.each do |vert|
        next if (horz < 0 || horz > 8) || (vert < 0 || vert > 8)
        num_bombs += 1 if @grid[horz][vert].value == :B
      end
    end
    num_bombs
  end




  def bombs_revealed?
    @grid.flatten.any? {|tile| tile.value == :B && tile.revealed == true }
  end

  def spaces_revealed?
    @grid.flatten.all? { |tile| tile.value == :B || tile.revealed == true}
  end

  def visual_row(row)
    row_string = ""
    row.each do |tile|
      if tile.flagged == true
        row_string << "  F"
      elsif tile.revealed == false
        row_string << "  *"
      elsif tile.value == :B
        row_string << "  #{"B".red}"
      elsif tile.value > 0
        row_string << "  #{tile.value.to_s}"
      else
        row_string << "  _"
      end
    end
    row_string
  end

  def create_tiles
    @grid.each do |row|
      row.each_with_index do |space, idx|
        row[idx] = Tile.new(get_value)
      end
    end
  end

  def get_value
    @all_values.pop
  end

  def populate_values

    number_of_bombs.times { all_values << :B }
    (size - number_of_bombs).times {  all_values << :e }

    all_values.shuffle!

  end

  def size
    @grid.flatten.count
  end

  def number_of_bombs
    size / @grid.length
  end

  def reveal_adjacent(pos)
    x,y = pos
  end
end
