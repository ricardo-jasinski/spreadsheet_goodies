
module SpreadsheetGoodies::GoogleDrive

  # Accesses GoogleDrive and returns a SpreadsheetGoodies::GoogleDrive::Worksheet
  def self.read_worksheet(spreadsheet_key:, worksheet_title:nil, num_header_rows:1)
    Worksheet.new(spreadsheet_key, worksheet_title, num_header_rows)
  end

end

# loads all files in google_drive folder
Dir[File.join(File.dirname(__FILE__), "google_drive/**/*.rb")].each { |f| require f }
