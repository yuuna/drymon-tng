# -*- coding: utf-8 -*-
require "rubygems"
require "hpricot"
require 'open-uri'
require "iconv"
require 'yaml'
require "active_support/core_ext"

module DrymonTng
  class Lime

    def initialize file
      if File::ftype(file) == "directory"
        Dir::glob(file+"/*.yml").each {|f|
          gen(f)
        }
      else
        gen(file)
      end
    end

    def gen filename

      data = YAML.load(open(filename).read)
      #domain用のフォルダー作成ルーチンを通すこと
      basedir = "output/"+URI.parse(data["domain"]).host
      unless File.exists?(basedir)
        Dir::mkdir(basedir)
      end

      unless File.exists?(basedir+"/lime")
        Dir::mkdir(basedir+"/lime")
      end
      basedir = basedir + "/lime"
      output =  "output/"+URI.parse(data["domain"]).host+"/lime/"+File::basename(filename)+".php"

      
      open(output, "w") do |f|
        puts 'output file: '+output
      end
    end
  end
end


if __FILE__ == $0
  hoge = DrymonTng::Lime.new("./yml")

end

