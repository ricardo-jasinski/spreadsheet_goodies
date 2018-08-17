module SpreadsheetGoodies

end

require 'spreadsheet_goodies/version'
require 'spreadsheet_goodies/google_drive'
require 'spreadsheet_goodies/excel'
require 'roo'

module SpreadsheetGoodies

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    attr_accessor :service_account_key_json, :login_method,
      :google_client_id, :client_secret,  :refresh_token, :strip_values_on_read

    def initialize
      @login_method = :oauth2
    end
  end

end
