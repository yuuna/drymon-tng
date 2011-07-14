# -*- coding: utf-8 -*-
require 'csv'
require 'drymon_tng/pne'

module DrymonTng
  module Pne
    class Table
      
      attr_accessor :openpne, :plugin_name
      def initialize plugin_name
        @openpne = YAML.load_file("config/openpne.yml")
        @plugin_name = plugin_name
      end

      def parse

        #ディレクトリの存在判定が必要

        datum =  `cd #{@openpne["install_dir"]}; ./symfony doctrine:data-load ./plugins/#{@plugin_name}/test/fixtures --trace`
        data_array = Array.new
        datum.split("\n").each do |row|
          if row =~ />> Doctrine_Connection_Statement execute : INSERT INTO ([a-zA-Z_]*) \(/
            data_array << $1
          end
        end
        data_array.uniq!
        print "------------ table list ------------"
        data_array.each do |table_name|
          print table_name
          print "\n"
        end

      end
      def self.args 
        opts = OptionParser.new("Usage: #{File::basename($0)} plugin-name")
        opts.on("-v", "--version", "show version") do
          puts "%s %s" %[File.basename($0), Drymon::Tng::VERSION]
          puts "ruby %s" % RUBY_VERSION
          exit
        end
        opts.version = DrymonTng::VERSION
        opts.parse!(ARGV)
        plugin_name = ARGV[0]
        unless plugin_name
          puts "Usage: #{File::basename($0)} plugin-name"
          exit
        end
        return plugin_name
      end
    end
  end
end


if __FILE__ == $0
  plugin = DrymonTng::Pne::Table.args
  pt = DrymonTng::Pne::Table.new(plugin)
  pt.parse

end
