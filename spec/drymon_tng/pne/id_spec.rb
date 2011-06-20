require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'drymon_tng/pne/id'

describe "DrymongTng::Pne::Id" do
  before(:all) do
    @filename = File.dirname(__FILE__) + '/../../fixture/action_list.album'
    @output_filename = File.dirname(__FILE__) + '/../../../config/openpne_id.yml'
    @dni = DrymonTng::Pne::Id.new(@filename)
  end

  it "should be equal filename of init" do
    @dni.filename.should == @filename
  end

  it "should be equal count of file" do
    @dni.parse
    @dni.list.count.should == 1
  end


  it "should be equal output format" do
    @dni.write
    @dni.output_list[0].should == "opAlbumPlugin: \n  id: 1\n"
  end

  it "should be equal output file" do
    out_f = File.open(@output_filename)
    out_f.read.should == "opAlbumPlugin: \n  id: 1\n"
    out_f.close
  end


end
