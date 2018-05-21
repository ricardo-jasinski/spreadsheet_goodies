require 'spec_helper'

module SpreadsheetGoodies
  describe Configuration do
    describe '#login_method' do
      it 'default value is :oauth2' do
        expect(Configuration.new.login_method).to eq(:oauth2)
      end
    end

    describe '#login_method=' do
      it 'can set value' do
        config = Configuration.new
        config.login_method = :service_account
        expect(config.login_method).to eq(:service_account)
      end
    end
  end
end