require 'spec_helper'

describe "Routes for batch_update" do
  it "should route index" do 
    expect(:get => '/batch_edits').to route_to( :controller => "batch_edits", :action => "index")
    expect(batch_edits_path).to eq('/batch_edits')
  end
  it "should route edit" do 
    expect(:get => edit_batch_edits_path).to route_to( :controller => "batch_edits", :action => "edit")
  end
  it "should route update" do 
    expect(:put => batch_edits_path).to route_to( :controller => "batch_edits", :action => "update")
  end
  it "should route delete batch" do 
    expect(:delete => batch_edits_path).to route_to( :controller => "batch_edits", :action => "destroy_collection")
  end
  it "should route add" do 
    expect(:put => '/batch_edits/7').to route_to( :controller => "batch_edits", :action => "add", :id=>'7')
  end
  it "should route delete" do 
    expect(:delete => '/batch_edits/7').to route_to( :controller => "batch_edits", :action => "destroy", :id=>'7')
    expect(batch_edit_path(7)).to eq("/batch_edits/7")
  end

  it "should route all" do 
    expect(:put => '/batch_edits/all').to route_to( :controller => "batch_edits", :action => "all")
    expect(all_batch_edits_path).to eq("/batch_edits/all")
  end


end
