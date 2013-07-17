# -*- encoding : utf-8 -*-
module Hydra
  module BatchEdit
    class Routes

      def initialize(router, options)
        @router = router
        @options = options
      end

      def draw
        add_routes do |options|
          resources :batch_edits, :only=>[:index] do
            member do
              delete :destroy
            end
            collection do
              get :index
              get :edit
              put :update
              delete :clear
              put :state
              put :all
            end
          end
          match 'batch_edits/:id' => 'batch_edits#add', :via=>:put
          match 'batch_edits' => 'batch_edits#destroy_collection', :via=>:delete
        end
      end

      protected

      def add_routes &blk
        @router.instance_exec(@options, &blk)
      end
    end
  end
end

