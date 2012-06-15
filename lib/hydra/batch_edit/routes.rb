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
              get :edit
              put :update
              delete :clear
              put :state
            end
          end
          match 'batch_edits/:id' => 'batch_edits#add', :via=>:put
        end
      end

      protected

      def add_routes &blk
        @router.instance_exec(@options, &blk)
      end
    end
  end
end

