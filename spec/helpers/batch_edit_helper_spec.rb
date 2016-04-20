require 'spec_helper'

describe BatchEditHelper do
  describe "batch_edit_active?" do
    it "when nil" do
      expect(helper.batch_edit_state).to eq('off')
    end
    it "should be off" do
      session[:batch_edit_state] = 'off'
      expect(helper.batch_edit_state).to eq('off')
    end
    it "should be on" do
      session[:batch_edit_state] = 'on'
      expect(helper.batch_edit_state).to eq('on')
    end
  end
end
