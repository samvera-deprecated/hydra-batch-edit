module BatchEditHelper 
  # determines if the given document id is in the batch
  def item_in_batch?(doc_id)
    session[:batch_document_ids] && session[:batch_document_ids].include?(doc_id) ? true : false
  end

  def batch_edit_active?
    session[:batch_update_state] == 'on'
  end

  def batch_edit_tools
    render :partial=>'/batch_updates/tools'
  end

  def batch_edit_continue 
    render :partial => '/batch_updates/next_page' 
  end

  def batch_edit_select(document)
    render :partial=>'/batch_updates/add_button', :locals=>{:document=>document}
  end
end
