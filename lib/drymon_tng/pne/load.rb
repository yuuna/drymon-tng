require 'csv'
require 'drymon_tng/pne'

module DrymonTng
  module Pne
    class Id
      class << self
        include DrymonTng::Pne
      end
      attr_accessor :filename, :list, :output_list
      def initialize filename
        @filename = filename
        @list = []
        @output_list = []
      end

      def parse
        if @list.length == 0
          @list = read
        end
        @list.each do |value|
          @output_list << sprintf("%s: \n  id: 1\n",value)
        end
      end

      def write
        if @output_list.size > 0
          file = open("config/openpne_id.yml","w")
          @output_list.each{|line| file.puts line}
          file.close
        end
      end
      def read
        #we should make option scheme

        File.open(filename) {|file|
          while l = file.gets
            @list << l.chomp!.split("\t")[1]
          end
        }
        @list.uniq!
      end



    end
  end
end


if __FILE__ == $0
  filename = DrymonTng::Pne::Id.args
  hoge = DrymonTng::Pne::Id.new(filename)
  hoge.parse
  hoge.write
end
