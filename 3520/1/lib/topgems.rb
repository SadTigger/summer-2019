require './lib/repo_scrapper'
require './lib/rubygems_links'
require './lib/tg_parse'
require './lib/output_table'
require './lib/backup'

# This class smell of :reek:InstanceVariableAssumption
class TopGems
  include Backup
  attr_reader :data

  def initialize
    @rg_links = RubyGemsLink.new
    @scraper = RepoScrapper.new
    @data = []
  end

  def parse_all_links
    @rg_links.yaml_links.each do |link|
      @scraper.get_repo_page(link)
      repo_info = @scraper.repo_info
      Backup.backup_create(repo_info[:name], repo_info)
    end
  end

  def gathering_data
    @rg_links.gems_name.each do |name|
      @data << Backup.backup_load(name)
    end
  end

  def data_sort
    @data.sort_by! { |el| el[:stars] }.reverse
  end

  def create_table(data)
    @output_table = OutputTable.new
    data.each { |dat| @output_table.add_value(dat) }
    puts @output_table.show_table
  end

  def base_table
    data_sort
  end

  def gem_toplist(top_number)
    data_sort.first(top_number)
  end

  def gems_by_name(name)
    data_sort.select! { |dat| dat[:name].include?(name) }
  end

  def parse_and_gathering_data
    Backup.delete_backup
    parse_all_links
    gathering_data
  end

  # This method smells of :reek:TooManyStatements
  def run(options)
    Backup.delete_backup if options[:delete]
    @rg_links.file = options[:file] if key_shortcut(options) == 'file'
    if Backup.backup_check @rg_links
      p 'I found backups!'
      gathering_data
    else
      p 'There is no backups. T_T'
      parse_and_gathering_data
    end
    show(options)
  end

  # This method smells of :reek:UtilityFunction
  def key_shortcut(options)
    case options.keys.first.to_s
    when 'name'
      'by_name'
    when 'delete' || 'file'
      'base'
    when 'top'
      'toplist'
    else
      'base'
    end
  end

  def table_to_show(options)
    return base_table if key_shortcut(options) == 'base'
    return gem_toplist(options[:top]) if key_shortcut(options) == 'toplist'
    return gems_by_name(options[:name]) if key_shortcut(options) == 'by_name'

    raise "Bad options #{options}"
  end

  def show(options)
    create_table table_to_show(options)
  end
end
