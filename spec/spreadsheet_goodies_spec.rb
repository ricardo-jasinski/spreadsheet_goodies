require 'spec_helper'

describe SpreadsheetGoodies do
  it 'has a version number' do
    expect(SpreadsheetGoodies::VERSION).not_to be nil
  end

  describe '#configure' do
    it 'sets the global configuration values' do
      SpreadsheetGoodies.configure do |config|
        config.service_account_key_json = '{}'
        config.login_method = :service_account
        config.google_client_id = 'MY_CLIENT_ID'
        config.client_secret = 'MY_CLIENT_SECRET'
        config.refresh_token = 'MY_REFRESH_TOKEN'
        config.strip_values_on_read = true
      end

      expect(SpreadsheetGoodies.configuration.service_account_key_json).to eq('{}')
      expect(SpreadsheetGoodies.configuration.login_method ).to eq(:service_account)
      expect(SpreadsheetGoodies.configuration.google_client_id ).to eq('MY_CLIENT_ID')
      expect(SpreadsheetGoodies.configuration.client_secret ).to eq('MY_CLIENT_SECRET')
      expect(SpreadsheetGoodies.configuration.refresh_token ).to eq('MY_REFRESH_TOKEN')
      expect(SpreadsheetGoodies.configuration.strip_values_on_read ).to eq(true)
    end
  end
end