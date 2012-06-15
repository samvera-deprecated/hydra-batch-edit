module BatchEditHelper 
  # determines if the given document id is in the batch
  def item_in_batch?(doc_id)
    session[:batch_document_ids] && session[:batch_document_ids].include?(doc_id) ? true : false
  end

  def batch_edit_active?
    session[:batch_edit_state] == 'on'
  end

  def batch_edit_tools
    render :partial=>'/batch_edit/tools'
  end

  def batch_edit_continue 
    render :partial => '/batch_edit/next_page' 
  end

  def batch_edit_select(document)
    render :partial=>'/batch_edit/add_button', :locals=>{:document=>document}
  end
end
