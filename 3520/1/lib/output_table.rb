# require 'terminal-table'
require 'tty-table'

HEADER = ['name', 'used by', 'watched by', 'stars', 'forks', 'contributors', 'issues'].freeze

class OutputTable
  def initialize
    @table = TTY::Table.new header: HEADER
  end

  def add_value(value)
    @table << value
  end

  def show_table
    @table.render :ascii, alignment: [:center], width: 80, resize: true do |renderer|
      renderer.border.separator = :each_row
    end
  end
end
