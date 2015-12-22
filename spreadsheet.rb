require "pp"

class Spreadsheet
  attr_accessor :cells

  def initialize
    @cells = {}
  end

  def add_cell(column, row, value)
    cell = Cell.new(self, column, row, value)
    cells[cell.location] = cell
  end

  def find_cell(location)
    location = location.upcase.to_sym
    cells[location]
  end

  def find_cell_content(location)
    location = location.upcase.to_sym
    cells[location].content if cells[location]
  end

  def print
    cells.each do |k, v|
      puts "#{v.location} - #{v.content}"
    end
    puts "\n"
  end
end

class Cell
  attr_accessor :value, :column, :row
  attr_reader :spreadsheet, :content, :location
  FORMULA_REGEX = /^[aA-zZ]/

  def initialize(spreadsheet, column, row, value = "")
    @spreadsheet = spreadsheet
    @column = column.upcase.strip
    @row = row.upcase.strip
    @value = value.upcase.strip
  end

  def location
    @location ||= (@column + @row).to_sym
  end

  def content
    if @value.match(FORMULA_REGEX)
      return "#ERR" if @value.to_sym == @location
      @content = spreadsheet.find_cell_content(@value)
    else
      @content = eval(@value)
    end
  end
end

spr = Spreadsheet.new
spr.add_cell("a", "   1  ", "10+5")
spr.add_cell("a", "2", "   20 + 50")
spr.add_cell("a", "3", "   a3")
spr.print
spr.add_cell("a", "3", "a4")
spr.print
spr.add_cell("a", "3", "a1")
spr.print



