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
  it "should add items to list" do
    @mock_response = mock()
    @mock_document = mock()
    @mock_document2 = mock()
    @mock_document.stub(:export_formats => {})
    controller.stub(:get_solr_response_for_field_values => [@mock_response, [@mock_document, @mock_document2]])

    put :add, :id =>"77826928"
    session[:batch_document_ids].length.should == 1
    put :add, :id => "94120425"
    session[:batch_document_ids].length.should == 2
    session[:batch_document_ids].should include("77826928")
    get :index
    assigns[:documents].length.should == 2
    assigns[:documents].first.should == @mock_document
  end
  it "should delete an item from list" do
    put :add, :id =>"77826928"
    put :add, :id => "94120425"
    delete :destroy, :id =>"77826928"
    session[:batch_document_ids].length.should == 1
    session[:batch_document_ids].should_not include("77826928")
  end
  it "should clear list" do
    put :add, :id =>"77826928"
    put :add, :id => "94120425"
    put :clear
    session[:batch_document_ids].length.should == 0
  end

  it "should generate flash messages for normal requests" do
    put :add, :id => "77826928"
    flash[:notice].length.should_not == 0
  end
  it "should clear flash messages after xhr request" do
    xhr :put, :add, :id => "77826928"
    flash[:notice].should == nil
  end
  
  it "should check for empty" do
    put :add, :id =>"77826928"
    put :add, :id => "94120425"
    controller.check_for_empty?.should == false
    put :clear
    controller.check_for_empty?.should == true
  end

  describe "edit" do
    before do
      @one = Sample.new
      @two = Sample.new
      @one.save
      @two.save
    end
    it "should draw the form" do
      put :add, :id =>@one.pid
      put :add, :id =>@two.pid
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
      put :add, :id =>@one.pid
      put :add, :id => @two.pid
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
        put :add, :id =>@one.pid
        put :add, :id => @two.pid
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
      put :add, :id =>@one.pid
      put :add, :id => @two.pid
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
        put :add, :id =>@one.pid
        put :add, :id => @two.pid
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
      session[:batch_document_ids].should == [123, 456]
    end
    it "ajax should add every document in the current resultset to the batch but not redirect" do
      xhr :put, :all
      response.should_not redirect_to edit_batch_edits_path
      session[:batch_document_ids].should == [123, 456]
    end
  end

  describe "clear" do
    it "should clear the batch"
  end

end
