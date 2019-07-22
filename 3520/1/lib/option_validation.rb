module OptionValidation
  def self.check_option(options)
    return 'base' if options.nil?

    case options.keys.first.to_s
    when 'name'
      'by_name'
    when 'file'
      'base'
    when 'top'
      'toplist'
    end
  end
end
