Hydra::BatchEdit::Engine.routes.draw do
  match 'batch_edits/:id' => 'batch_edit#add', :via=>:put
  resources :batch_edits, :only=>[:index] do
    member do
      delete :destroy
    end
    collection do
      get :edit
      put :update
      delete :clear
    end
  end
end
