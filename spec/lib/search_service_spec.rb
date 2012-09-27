require 'spec_helper'

describe Hydra::BatchEdit::SearchService do

  before do
    @session = {:history => [17, 14, 12, 9]}
    @service = Hydra::BatchEdit::SearchService.new(@session, 'vanessa')
  end

  it "should get the documents for the first history entry" do
    Search.should_receive(:find).with(17).and_return(Search.new(:query_params=>{:q=>"World Peace"}))
    @service.should_receive(:get_search_results).and_return([:one, [:doc1, :doc2]])
    @service.last_search_documents.should == [:doc1, :doc2]

  end

end
