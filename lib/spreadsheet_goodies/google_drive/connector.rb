require 'google_drive'
require 'googleauth'

module SpreadsheetGoodies::GoogleDrive
  class Connector
    attr_reader :logger, :session

    def initialize
      @logger = Logger.new(STDOUT)
      @session = log_into_google_drive
      raise 'Session not found!' unless @session
    end

    # Reads a GoogleDrive::Spreadsheet object from Google Drive, using the
    # google_drive gem. Documentation for this class can be found here:
    # https://www.rubydoc.info/github/gimite/google-drive-ruby/GoogleDrive/Spreadsheet
    def read_worksheet(spreadsheet_key, worksheet_title=nil)
      puts "Reading sheet '#{worksheet_title}' from Google Drive..."
      spreadsheet = @session.spreadsheet_by_key(spreadsheet_key)

      if worksheet_title
        worksheet = spreadsheet.worksheet_by_title(worksheet_title)
        if worksheet.nil?
          raise "Worksheet named '#{worksheet_title}' not found in spreadsheet."
        end
      else
        worksheet = spreadsheet.worksheets.first
      end

      worksheet
    end

    def read_worksheet_as_string(spreadsheet_key, worksheet_title)
      worksheet = read_worksheet(spreadsheet_key, worksheet_title)
      contents = worksheet.export_as_string.force_encoding('utf-8')
      puts 'Spreadsheet read successfully.'
      contents
    end

  private

    def log_into_google_drive
      case SpreadsheetGoodies.configuration.login_method
      when :service_account then log_into_google_drive_via_service_account
      when :oauth2 then log_into_google_drive_via_oauth2
      end
    end

    # Authenticate with Google Drive via OAuth2.
    # Your OAuth2 ids can be accessed at https://console.developers.google.com/apis/credentials,
    # logged with your Google account in your custom project. The keys are at
    # 'API manager' > 'Credentials'. CLIENT_ID and CLIENT_SECRET are available
    # from the credentials page. The REFRESH_TOKEN must be obtained uncommenting
    # some rows from the method below and obtaining an access_token via a browser
    # logged in to your google account.
    def log_into_google_drive_via_oauth2
      credentials = Google::Auth::UserRefreshCredentials.new(
        client_id: SpreadsheetGoodies.configuration.google_client_id,
        client_secret: SpreadsheetGoodies.configuration.client_secret,
        scope: [
          'https://www.googleapis.com/auth/drive',
          'https://spreadsheets.google.com/feeds/',
        ],
        redirect_uri: 'urn:ietf:wg:oauth:2.0:oob'
      )

      # if has refresh_token, logs in
      if SpreadsheetGoodies.configuration.refresh_token
        credentials.refresh_token = SpreadsheetGoodies.configuration.refresh_token

      # if refresh_token is missing, prompts user to obtain it
      else
        print("1. Open this page:\n%s\n\n" % credentials.authorization_uri)
        print("2. Enter the authorization code shown in the page: ")
        credentials.code = $stdin.gets.chomp
        credentials.fetch_access_token!
        print("\nCongratulations! Your refresh token is: #{credentials.refresh_token}\n")
        print("Set the refresh_token in your SpreadsheetGoodies configuration and run your code again\n")
        exit(0)
      end

      begin
        credentials.fetch_access_token!
      rescue Faraday::ConnectionFailed
        logger.info 'Error logging into Google Drive. Is your internet connection down?'
        exit
      end

      session = GoogleDrive::Session.from_credentials(credentials)
    end

    # Authenticate with Google Drive via a service account.
    # Your service accounts can be accessed at https://console.developers.google.com/apis/credentials,
    # logged with your Google account in your custom project.
    # The service accounts are at 'IAM and administrator' > 'Service accounts'.
    # The keys are at 'API manager' > 'Credentials'.
    def log_into_google_drive_via_service_account
      session = GoogleDrive::Session.from_service_account_key(
        StringIO.new(SpreadsheetGoodies.configuration.service_account_key_json)
      )
      session
    end
  end
end
