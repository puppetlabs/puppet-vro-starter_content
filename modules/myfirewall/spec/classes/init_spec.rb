require 'spec_helper'
describe 'myfirewall' do

  context 'with defaults for all parameters' do
    it { should contain_class('myfirewall') }
  end
end
