require 'spec_helper'

describe "Routes for batch_update" do
  it "should route index" do 
    { :get => '/batch_edits' }.should route_to( :controller => "batch_edits", :action => "index")
  end
  it "should route edit" do 
    { :get => edit_batch_edits_path }.should route_to( :controller => "batch_edits", :action => "edit")
  end
  it "should route update" do 
    { :put => batch_edits_path }.should route_to( :controller => "batch_edits", :action => "update")
  end
  it "should route add" do 
    { :put => '/batch_edits/7'}.should route_to( :controller => "batch_edits", :action => "add", :id=>'7')
  end
  it "should route delete" do 
    { :delete => '/batch_edits/7' }.should route_to( :controller => "batch_edits", :action => "destroy", :id=>'7')
    batch_edit_path(7).should == "/batch_edits/7"
  end

  it "should route all" do 
    { :put => '/batch_edits/all'}.should route_to( :controller => "batch_edits", :action => "all")
    all_batch_edits_path.should == "/batch_edits/all"
  end


end
