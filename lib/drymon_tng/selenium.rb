# -*- coding: utf-8 -*-
require "rubygems"
require "hpricot"
require 'open-uri'
require "iconv"
require 'yaml'
require "active_support/core_ext"

module DrymonTng
  class Selenium

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

      unless File.exists?(basedir+"/selenium")
        Dir::mkdir(basedir+"/selenium")
      end
      basedir = basedir + "/selenium"
      output =  "output/"+URI.parse(data["domain"]).host+"/selenium/"+File::basename(filename)+".php"

      open(output, "w") do |f|
        f.write <<"EOS"
<?php
require_once 'PHPUnit/Extensions/SeleniumTestCase.php';
class WebTest extends PHPUnit_Extensions_SeleniumTestCase
  {
    protected function setUp()
    {
      $this->setBrowser('*firefox');
      $this->setBrowserUrl('#{data["domain"]}');
    }
EOS
    assertValue = String("");
    testclassname = String("")
    data.each do |row_d|
      if row_d.instance_of?(Array) != false 
        if row_d[0] == "response"
          row_d[1].each do |key,value|
            assertValue += "$this->assertTrue((bool)preg_match($this->isTextPresent(\"#{$value}\")));\n";
          end
        end
        if row_d[0] == "actions" 
          submit_data = String("")
          post_data = String("")
          
          
          row_d[1].each do |row|
            if row.has_key?("post_params") 
              testclassname = row["module"].to_s.classify + row["action"].to_s.classify
              row["post_params"].each do |key2,value|
                post_data = post_data + "\t\t\t$this->type(\"#{key2}\",\"#{value}\"); \n"
              end
              if testclassname == ""
                testclassname = "Login"
              end
              f.write <<"EOS"
      function test#{testclassname}()
      {
      $this->open("#{row["path"]}");
      #{post_data}
      $this->click("submit");
      $this->waitForPageToLoad("30000");
      #{assertValue}
      }
}
?>
EOS
              
            end
          end
        end
      end
    end
  end
    puts 'output file: '+output
  end
end
end

if __FILE__ == $0
  hoge = DrymonTng::Selenium.new("./yml")

end

