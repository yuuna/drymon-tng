require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "DrymongTng::Pne::Get" do
  before(:all) do
    @filename = File.dirname(__FILE__) + '/../../fixture/action_list.album'
    @id_filename = File.dirname(__FILE__) + '/../../../config/openpne_id.yml'
    @dpg = DrymonTng::Pne::Get.new(@filename)
  end

  it "should be same rows" do
    @dpg.read
    @dpg.list.size.should == 19
  end

  it "should be fixture is accurate" do
    @dpg.fixture["opAlbumPlugin"]["id"] == 1
  end

  it "should be implement fixture test 1" do
    @dpg.fixture["opAlbumPlugin"]["album_show"] = "/album/2"
    @dpg.implement
    @dpg.list["album_show"][3].should == "/album/2"
  end

  it "should be implement fixture test 2" do
    @dpg.list["album_image_add"][3].should == "/album/1/photo/add"
  end

  it "should be login to OpenPne" do

  end
    


end
