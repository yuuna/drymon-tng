# -*- coding: utf-8 -*-
require "rubygems"
require "hpricot"
require 'open-uri'
require "iconv"
require 'yaml'
require "mechanize"
require "uri"
require 'csv'
require 'syck/encoding'
require 'drymon_tng/pne'
require "progressbar"
require 'logger'

module DrymonTng
  module Pne
    class Get
      class << self
        include DrymonTng::Pne
      end
      attr_accessor :filename, :list, :fixture, :openpne, :forms, :pbar, :access_log, :error_log
      def initialize filename
        @filename = filename
        @list = {}
        @fixture = YAML.load_file("config/openpne_id.yml")
        @openpne = YAML.load_file("config/openpne.yml")

        @forms = Hash.new
        @forms["domain"] = @openpne['domain']      
        @forms["actions"] = Array.new
        @access_log = Logger.new("./log/access_log")
        @error_log = Logger.new("./log/error_log")

        if @openpne["path"] == "/"
          @openpne["path"] = ""
        end
      end

      def parse
        if @list.length == 0
          @list = read
        end
      end


      def implement
        @list.each do |key,line|
          
          if line[3] =~ /:/ && line.length == 5
            if @fixture[line[1]].has_key?(key)
              line[3] = @fixture[line[1]][key]
            else
             line[3] = line[3].sub!(":id",@fixture[line[1]]["id"].to_s)
            end
          end
        end
      end

      def get
        i = 1;
        @list.each do |key,row|
          if row.length == 2
            uri = "/"+row[0]
          elsif row.length == 5
            uri = row[3]
          end
          
          begin

          #こっから
          agent = Mechanize.new
          agent.user_agent = "Mozilla"
          page = agent.get(@openpne['domain']+@openpne['path'])
          form = page.forms.first
          form.field_with(:name => 'authMailAddress[mail_address]').value = @openpne['username']
          form.field_with(:name => 'authMailAddress[password]').value = @openpne['password']
          result = agent.submit(form)

          action = {"path" => form.action,"method" => form.method,
            "post_params" => {"authMailAddress[mail_address]" => @openpne['username'],
              "authMailAddress[password]" => @openpne['password'],
              "authMailAddress[next_uri]" => "member/login"}}

          @forms["actions"] << action
          action = {"path" => @openpne["path"]+uri}
          @forms["actions"] << action

          output_flag = false
          output = ""
          agent.get(@openpne["path"]+uri).forms.each do |form|
              forms = @forms.clone
              unless form.action =~ /language/           
                action=Hash.new
                action["path"] = form.action
                
                action["method"] = form.method
                action["module"] = @module ||nil 
                action["action"] = @action ||nil
                action["post_params"] = Hash[*form.build_query.flatten]
                action["post_params"].each { |key,value|
                if key =~ /_csrf_token/
                  action["post_params"][key] = "%(_csrf_token)%"
                  curpage = forms["actions"].pop
                  curpage["class"] = "RegexpSetVarAction"
                  curpage["expr"] = "name=\"#{key.gsub("[","\\[").gsub("]","\\]")}\" value=\"(\\w+)\""
                  curpage["key"] =  "_csrf_token"
                  forms["actions"] << curpage
                else
                  action["post_params"][key] = value.to_s
                end
                  
                }
                if action["path"] != "" || action["path"] != nil
                  forms["actions"] << action
                  forms["response"] = {"tag" => "value"}
                  output = forms
                  output_flag = true
                end
            end
            end
            if output_flag == false
              output = @forms
            end
            @access_log.info("Writing :"+uri + ":" +write(output,row,i,uri))
            @forms["actions"] =Array.new
            @forms["response"] = {}
            @pbar.inc
          rescue => e
            @error_log.fatal("Error is occured when reading :"+uri)
            @error_log.fatal(e)

            @forms["actions"] =Array.new
            @forms["response"] = {}
            @pbar.inc
            
          end
          i += 1
        end
        @pbar.finish
        
      end
      def setprog num
        @pbar = ProgressBar.new("pne",num,$stderr)
      end

      def write output,row,i,uri
        uri.gsub!("/","_")
        filename = "./yml/#{i}_#{row[1]}_#{uri}.yml"

        hakaiheader = {"loop" => 10,"max_request" =>  5,"max_scenario" => 5,"log_level" =>  2, "ranking" => 20,"timeout"=> 5,"show_report" =>  true,"save_report" =>  false,"encoding" => "UTF-8"}

        open(filename, "w") do |f|
          f.write(Syck::unescape(YAML::dump(hakaiheader)).gsub("---",""))
          f.write(Syck::unescape(YAML::dump(output)).gsub("---",""))
          f.flush
        end
        return filename
      end
      def read
        #we should make option scheme
        File.open(filename) {|file|
          while l = file.gets
            row =  l.chomp!.split("\t")
            if row.length == 2
              key = row[0]
            elsif row.length == 5
              key = row[2]
            else
              @error_log.fatal("Error is occred when reading list file.")
              @error_log.fatal(row.join(","))
            end
            @list[key] = row
          end
        }
        setprog(@list.count)
      end
    end
  end
end


if __FILE__ == $0
  filename = DrymonTng::Pne::Get.args
  dpi = DrymonTng::Pne::Get.new(filename)
  dpi.read
  dpi.implement
  dpi.get
end
