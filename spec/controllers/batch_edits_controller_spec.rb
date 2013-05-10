require 'spec_helper'

describe BatchEditsController do
  before(:each) do
    request.env["HTTP_REFERER"] = "/"
  end
  it "should respond to after_update" do
    controller.respond_to? "after_update"
  end
  it "should respond to update_document" do
    controller.respond_to? "update_document"
  end
  it "should respond to after_delete" do
    controller.respond_to? "after_delete"
  end

  describe "edit" do
    before do
      @one = Sample.new
      @two = Sample.new
      @one.save
      @two.save
    end
    it "should draw the form" do
      controller.batch = [@one.pid, @two.pid]
      controller.should_receive(:can?).with(:edit, @one.pid).and_return(true)
      controller.should_receive(:can?).with(:edit, @two.pid).and_return(true)
      get :edit
      response.should be_successful
      
    end
  end


  describe "update" do
    before :all do
      @one = Sample.create
      @two = Sample.create
    end
    before do
      controller.stub(:catalog_index_path).and_return('/catalog')
      request.env["HTTP_REFERER"] = "where_i_came_from"
      
    end
    it "should complain when none are in the batch " do
      put :update, :multiresimage=>{:titleSet_display=>'My title' } 
      response.should redirect_to 'where_i_came_from'
      flash[:notice].should == "Select something first"
    end
    it "should not update when the user doesn't have permissions" do
      controller.batch = [@one.pid, @two.pid]
      controller.should_receive(:can?).with(:edit, @one.pid).and_return(false)
      controller.should_receive(:can?).with(:edit, @two.pid).and_return(false)
      put :update, :multiresimage=>{:titleSet_display=>'My title' } 
      response.should redirect_to 'where_i_came_from'
      flash[:notice].should == "You do not have permission to edit the documents: #{@one.pid}, #{@two.pid}"
    end
    describe "when current user has access to the documents" do
      before do
        @one.save
        @two.save
        controller.batch = [@one.pid, @two.pid]
        controller.should_receive(:can?).with(:edit, @one.pid).and_return(true)
        controller.should_receive(:can?).with(:edit, @two.pid).and_return(true)
        ActiveFedora::Base.should_receive(:find).with( @one.pid, :cast=>true).and_return(@one)
        ActiveFedora::Base.should_receive(:find).with( @two.pid, :cast=>true).and_return(@two)
      end
      it "should update all the field" do
        put :update, :sample=>{:titleSet_display=>'My title' } 
        response.should redirect_to '/catalog'
        flash[:notice].should == "Batch update complete"
        Sample.find(@one.pid).titleSet_display.should == "My title"
      end
      it "should not update blank values" do
        @one.titleSet_display = 'Original value'
        put :update, :sample=>{:titleSet_display=>'' } 
        response.should redirect_to '/catalog'
        flash[:notice].should == "Batch update complete"
        Sample.find(@one.pid).titleSet_display.should == "Original value"
      end
    end
  end

  describe "delete_collection" do
    before :all do
      @one = Sample.create
      @two = Sample.create
    end
    before do
      controller.stub(:catalog_index_path).and_return('/catalog')
      request.env["HTTP_REFERER"] = "where_i_came_from"      
    end
    it "should complain when none are in the batch " do
      delete :destroy_collection 
      response.should redirect_to 'where_i_came_from'
      flash[:notice].should == "Select something first"
    end
    it "should not update when the user doesn't have permissions" do
      controller.batch = [@one.pid, @two.pid]
      controller.should_receive(:can?).with(:edit, @one.pid).and_return(false)
      controller.should_receive(:can?).with(:edit, @two.pid).and_return(false)
      delete :destroy_collection 
      response.should redirect_to 'where_i_came_from'
      flash[:notice].should == "You do not have permission to edit the documents: #{@one.pid}, #{@two.pid}"
    end
    describe "when current user has access to the documents" do
      before do
        @one.save
        @two.save
        controller.batch = [@one.pid, @two.pid]
        controller.should_receive(:can?).with(:edit, @one.pid).and_return(true)
        controller.should_receive(:can?).with(:edit, @two.pid).and_return(true)
        ActiveFedora::Base.should_receive(:find).with( @one.pid, :cast=>true).and_return(@one)
        ActiveFedora::Base.should_receive(:find).with( @two.pid, :cast=>true).and_return(@two)
      end
      it "should update all the field" do
        delete :destroy_collection 
        response.should redirect_to '/catalog'
        flash[:notice].should == "Batch delete complete"
        Sample.find(@one.pid).should be_nil
        Sample.find(@two.pid).should be_nil
      end
    end
  end

  describe "state" do
    it "should save state on" do
      xhr :put, :state, :state=>'on'
      response.should be_successful
      session[:batch_edit_state].should == 'on'
    end
    it "should save state off" do
      xhr :put, :state, :state=>'off'
      response.should be_successful
      session[:batch_edit_state].should == 'off'
    end
  end

  describe "select all" do
    before do
      doc1 = stub(:id=>123)
      doc2 = stub(:id=>456)
      Hydra::BatchEdit::SearchService.any_instance.should_receive(:last_search_documents).and_return([doc1, doc2])
      controller.stub(:current_user=>stub(:user_key=>'vanessa'))
    end
    it "should add every document in the current resultset to the batch" do
      put :all
      response.should redirect_to edit_batch_edits_path
      controller.batch = [123, 456]
    end
    it "ajax should add every document in the current resultset to the batch but not redirect" do
      xhr :put, :all
      response.should_not redirect_to edit_batch_edits_path
      controller.batch = [123, 456]
    end
  end

  describe "clear" do
    it "should clear the batch"
  end

end
