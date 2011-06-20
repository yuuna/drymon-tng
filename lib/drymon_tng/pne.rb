require "optparse"
require 'drymon_tng'


module DrymonTng
  module Pne
    def args 
      opts = OptionParser.new("Usage: #{File::basename($0)} action-list")
      opts.on("-v", "--version", "show version") do
        puts "%s %s" %[File.basename($0), Drymon::TngVERSION]
        puts "ruby %s" % RUBY_VERSION
        exit
      end
      opts.version = DrymonTng::VERSION
      opts.parse!(ARGV)
      filename = ARGV[0]
      unless filename
        puts "Usage: #{File::basename($0)} action-list"
        exit
      end
      return filename
    end
  end
end

