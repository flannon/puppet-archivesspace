require 'spec_helper'
describe 'archivesspace' do

  context 'with defaults for all parameters' do
    it { should contain_class('archivesspace') }
  end
end
