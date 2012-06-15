module BatchUpdatesBehavior
  
  before_filter :filter_docs_with_access!, :only=>[:edit, :update]
  before_filter :check_for_empty!, :only=>[:edit, :update]

  
  # fetch the documents that match the ids in the folder
  def index
    @response, @documents = get_solr_response_for_field_values("id", batch)
  end

  def state
    session[:batch_edit_state] = params[:state]
    render :json => {"OK" => "OK"}
  end

  # add a document_id to the batch. :id of action is solr doc id 
  def add
    batch << params[:id] 
    respond_to do |format|
      format.html do
        redirect_to :back, :notice =>  "#{params[:title] || "Item"} successfully added to batch"
      end
      format.js { render :json => batch }
    end
  end
 
  # remove a document_id from the batch. :id of action is solr_doc_id
  def destroy
    batch.delete(params[:id])
    respond_to do |format|
      format.html do
        redirect_to :back, :notice => "#{params[:title] || "Item"} successfully removed from batch"
      end
      format.js do
        render :json => {"OK" => "OK"}
      end
    end
          
  end
 
  # get rid of the items in the batch
  def clear
    clear_batch!
    respond_to do |format|
      format.html { redirect_to :back, :notice=> "Batch has been cleared" }
      format.js { render :json => batch }
    end
  end

  def edit
  end

  def update
    batch.each do |doc_id|
      obj = ActiveFedora::Base.find(doc_id, :cast=>true)
      type = obj.class.to_s.underscore.to_sym
      obj.update_attributes(params[type])
      obj.save
    end
    flash[:notice] = "Batch update complete"
    clear_batch!
    redirect_to catalog_index_path
    
  end

  protected

  def batch
    session[:batch_document_ids] ||= []
  end

  def clear_batch!
    session[:batch_document_ids] = []
  end

  def check_for_empty!
    if batch.empty?
      redirect_to catalog_index_path
      return false
    end
  end
  
  def filter_docs_with_access!
    no_permissions = []
    if batch.empty?
      flash[:notice] = "Select something first"
    else
      batch.dup.each do |doc_id|
        unless can?(:edit, doc_id)
          session[:batch_document_ids].delete(doc_id)
          no_permissions << doc_id
        end
      end
      flash[:notice] = "You do not have permission to edit the documents: #{no_permissions.join(', ')}" unless no_permissions.empty?
    end
  end

end
