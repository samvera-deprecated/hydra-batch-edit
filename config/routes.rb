Hydra::BatchEdit::Engine.routes.draw do
  match 'batch_updates/:id' => 'batch_updates#add', :via=>:put
  resources :batch_updates, :only=>[:index] do
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
