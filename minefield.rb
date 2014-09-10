class Minefield
  attr_reader :row_count, :column_count, :mine_count, :cleared_cells, :mines

  def initialize(row_count, column_count, mine_count)
    @column_count = column_count
    @row_count = row_count
    @mine_count = mine_count

    @cleared_cells = []
    @mines = place_mines
  end


    ##########################
    # methods called in minesweeper.rb
    ##########################

    def cell_cleared?(row, col)
      cleared_cells.include?([row, col])
    end

    def clear(row, col)
      cleared_cells << [row, col]
      return if adjacent_mines(row, col) != 0

      adj_cells(row, col).each do |cell|
        clear(*cell) unless cleared_cells.include?(cell)
      end

    end

    def any_mines_detonated?
      cleared_cells.any? { |cell| mines.include?(cell) }
      # cleared_cells.each do |cell|
      #   return true if mines.include?(cell)
      # end
      #
      # false
    end

    def all_cells_cleared?
      size = row_count * column_count
      (cleared_cells.length + mines.length) == size
    end

    def adjacent_mines(row, col)
      adj_mine_count = 0

      adj_cells(row, col).each do |cell|
        adj_mine_count += 1 if contains_mine?(*cell)
      end

      adj_mine_count
    end

    def contains_mine?(row, col)
      mines.include?([row, col])
    end

  #########################
  # methods I added
  #########################

  private

  def place_mines
    mines = []
    mine_count.times do
      mines << [rand(row_count), rand(column_count)]
    end
    mines
  end

  #Adam's method -- this would be faster for a very large minefield b/c instead of iterating through the array of arrays each time, you could just call the index of the hash

#   def contains_mine?(row, col)
# 51:    field[index(row, col)][:mine]
# 52:  end
# 53:
# 54:  private
# 55:
# 56:  def index(row, col)
# 57:    (row * column_count) + col
# 58:  end

#   def generate_minefield(row_count, column_count, mine_count)
# 77:    cell_count = row_count * column_count
# 78:    minefield = []
# 79:
# 80:    cell_count.times do
# 81:      minefield << { mine: false, cleared: false }
# 82:    end
# 83:
# 84:    mine_count.times do
# 85:      index = rand(cell_count)
# 86:
# 87:      while minefield[index][:mine]
# 88:        index = rand(cell_count)
# 89:      end
# 90:
# 91:      minefield[index][:mine] = true
# 92:    end
# 93:
# 94:    minefield
# 95:  end

  def valid?(row, col)
    row >= 0 && row < row_count && col >= 0 && col < column_count
  end

  def poss_adj_cells(row, col)
    [
      [row + 1, col + 1],
      [row + 1, col],
      [row + 1, col - 1],
      [row, col + 1],
      [row, col - 1],
      [row - 1, col + 1],
      [row - 1, col],
      [row - 1, col - 1]
    ]
  end

  def adj_cells(row, col)
    adj = []

    poss_adj_cells(row, col).each do |cell|
      adj << cell if valid?(*cell)
    end

    adj
  end

end
