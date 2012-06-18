require 'spec_helper'

describe BatchEditHelper do
  describe "batch_edit_active?" do
    it "when nil" do
      helper.batch_edit_state.should == 'off'
    end
    it "should be off" do
      session[:batch_edit_state] = 'off'
      helper.batch_edit_state.should == 'off'
    end
    it "should be on" do
      session[:batch_edit_state] = 'on'
      helper.batch_edit_state.should == 'on'
    end
  end
end
