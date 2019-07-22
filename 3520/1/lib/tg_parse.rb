require 'optparse'

class TGParse
  def initialize
    @options = {}
  end

  def self.parse
    OptionParser.new do |opt|
      opt.on('-t', '--top=TOP', Integer, 'Show toplist of gems.')
      opt.on('-n', '--name=NAME', String, 'Show list of gems with name is.')
      opt.on('-f', '--file=FILE', String, 'Show path for gems.yml.')
    end.parse!(into: @options)
    @options
  end
end
