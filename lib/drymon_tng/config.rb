# -*- coding: utf-8 -*-
require "rubygems"
require "hpricot"
require 'open-uri'
require "iconv"
require 'yaml'
require "optparse"
require 'uri'

module DrymonTng
  class Config
   def self.copy
     unless File.exists?("./config")
       Dir::mkdir("./config")
     end
     unless File.exists?("./log")
       Dir::mkdir("./log")
     end
     FileUtils.cp(File.expand_path("../../../config", __FILE__)+'/openpne.yml','./config/') 
     unless File.exists?("./yml")
       Dir::mkdir("./yml")
     end
     unless File.exists?("./output")
       Dir::mkdir("./output")
     end

   end
  end
end

