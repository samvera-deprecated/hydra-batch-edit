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
      expect(controller).to receive(:can?).with(:edit, @one.pid).and_return(true)
      expect(controller).to receive(:can?).with(:edit, @two.pid).and_return(true)
      get :edit
      expect(response).to be_successful
      
    end
  end


  describe "update" do
    before :all do
      @one = Sample.create
      @two = Sample.create
    end
    before do
      allow(controller).to receive(:catalog_index_path).and_return('/catalog')
      request.env["HTTP_REFERER"] = "where_i_came_from"
      
    end
    it "should complain when none are in the batch " do
      put :update, :multiresimage=>{:titleSet_display=>'My title' } 
      expect(response).to redirect_to 'where_i_came_from'
      expect(flash[:notice]).to eq("Select something first")
    end
    it "should not update when the user doesn't have permissions" do
      controller.batch = [@one.pid, @two.pid]
      expect(controller).to receive(:can?).with(:edit, @one.pid).and_return(false)
      expect(controller).to receive(:can?).with(:edit, @two.pid).and_return(false)
      put :update, :multiresimage=>{:titleSet_display=>'My title' } 
      expect(response).to redirect_to 'where_i_came_from'
      expect(flash[:notice]).to eq("You do not have permission to edit the documents: #{@one.pid}, #{@two.pid}")
    end
    describe "when current user has access to the documents" do
      before do
        @one.save
        @two.save
        controller.batch = [@one.pid, @two.pid]
        expect(controller).to receive(:can?).with(:edit, @one.pid).and_return(true)
        expect(controller).to receive(:can?).with(:edit, @two.pid).and_return(true)
        expect(ActiveFedora::Base).to receive(:find).with( @one.pid, :cast=>true).and_return(@one)
        expect(ActiveFedora::Base).to receive(:find).with( @two.pid, :cast=>true).and_return(@two)
      end
      it "should update all the field" do
        put :update, :sample=>{:titleSet_display=>'My title' } 
        expect(response).to redirect_to '/catalog'
        expect(flash[:notice]).to eq("Batch update complete")
        expect(Sample.find(@one.pid).titleSet_display).to eq("My title")
      end
      it "should not update blank values" do
        @one.titleSet_display = 'Original value'
        put :update, :sample=>{:titleSet_display=>'' } 
        expect(response).to redirect_to '/catalog'
        expect(flash[:notice]).to eq("Batch update complete")
        expect(Sample.find(@one.pid).titleSet_display).to eq("Original value")
      end
    end
  end

  describe "delete_collection" do
    before :all do
      @one = Sample.create
      @two = Sample.create
    end
    before do
      allow(controller).to receive(:catalog_index_path).and_return('/catalog')
      request.env["HTTP_REFERER"] = "where_i_came_from"      
    end
    it "should complain when none are in the batch " do
      delete :destroy_collection 
      expect(response).to redirect_to 'where_i_came_from'
      expect(flash[:notice]).to eq("Select something first")
    end
    it "should not update when the user doesn't have permissions" do
      controller.batch = [@one.pid, @two.pid]
      expect(controller).to receive(:can?).with(:edit, @one.pid).and_return(false)
      expect(controller).to receive(:can?).with(:edit, @two.pid).and_return(false)
      delete :destroy_collection 
      expect(response).to redirect_to 'where_i_came_from'
      expect(flash[:notice]).to eq("You do not have permission to edit the documents: #{@one.pid}, #{@two.pid}")
    end
    describe "when current user has access to the documents" do
      before do
        @one.save
        @two.save
        controller.batch = [@one.pid, @two.pid]
        expect(controller).to receive(:can?).with(:edit, @one.pid).and_return(true)
        expect(controller).to receive(:can?).with(:edit, @two.pid).and_return(true)
        expect(ActiveFedora::Base).to receive(:find).with( @one.pid, :cast=>true).and_return(@one)
        expect(ActiveFedora::Base).to receive(:find).with( @two.pid, :cast=>true).and_return(@two)
      end
      it "should update all the field" do
        delete :destroy_collection 
        expect(response).to redirect_to '/catalog'
        expect(flash[:notice]).to eq("Batch delete complete")
        expect(Sample.find(@one.pid)).to be_nil
        expect(Sample.find(@two.pid)).to be_nil
      end
    end
  end

  describe "state" do
    it "should save state on" do
      xhr :put, :state, :state=>'on'
      expect(response).to be_successful
      expect(session[:batch_edit_state]).to eq('on')
    end
    it "should save state off" do
      xhr :put, :state, :state=>'off'
      expect(response).to be_successful
      expect(session[:batch_edit_state]).to eq('off')
    end
  end

  describe "select all" do
    before do
      doc1 = double(id: 123)
      doc2 = double(id: 456)
      expect_any_instance_of(CurationConcerns::Collections::SearchService).to receive(:last_search_documents).and_return([doc1, doc2])
      allow(controller).to receive_messages(current_user: double(user_key: 'vanessa'))
    end
    it "should add every document in the current resultset to the batch" do
      put :all
      expect(response).to redirect_to edit_batch_edits_path
      controller.batch = [123, 456]
    end
    it "ajax should add every document in the current resultset to the batch but not redirect" do
      xhr :put, :all
      expect(response).not_to redirect_to edit_batch_edits_path
      controller.batch = [123, 456]
    end
  end

  describe "clear" do
    it "should clear the batch"
  end

end
