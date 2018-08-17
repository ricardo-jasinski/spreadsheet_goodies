require 'csv'
require_relative '../abstract_base_worksheet'
require_relative '../row'

# A cached copy of a Google Spreadsheets worksheet (i.e., a single workbook "tab"),
# Individual cells of a row can be accessed by column title.
# Example:
#   worksheet[0]['A column title']
module SpreadsheetGoodies::GoogleDrive
  class Worksheet < SpreadsheetGoodies::AbstractBaseWorksheet
    # @param spreadsheet_key [String] Spreadsheet identifier, which can be retrieved
    #   from the spreasheet's url
    # @param worksheet_title_or_index [String] Sheet name; if unspecified, the
    #   first sheet will be used.
    # @param num_header_rows [Integer] Number of rows at the top of the sheet that
    #   contain headers or stuff other than data. Optional; if unspecified, assumes
    #   that a single top row contains the header and all rows below are data.
    def initialize(spreadsheet_key, worksheet_title=nil, num_header_rows=1)
      @spreadsheet_key = spreadsheet_key
      @worksheet_title = worksheet_title
      @num_header_rows = num_header_rows

      read_from_google_drive
    end

    # Writes to a given cell identified by row and column indexes (they start at 1)
    # @override
    def write_to_cell(row_index, col_index, value)
      underlying_adapter_worksheet[row_index, col_index] = value
    end

    # Commit writes so they are propagated to the real spreadsheet
    # @override
    def commit_writes!
      underlying_adapter_worksheet.save
    end

  private

    # Reads sheet contents and caches it into instance variables to so that it
    # can be accessed later without accessing Google Drive.
    def read_from_google_drive
      worksheet_contents = underlying_adapter_worksheet.export_as_string.force_encoding('utf-8')

      rows = CSV::parse(worksheet_contents)

      if SpreadsheetGoodies.configuration.strip_values_on_read
        rows = rows.map do |row|
          row.map {|element| element.try(:strip) }
        end
      end

      @header_row = rows[@num_header_rows-1]
      @rows = rows.collect.with_index do |row, index|
        SpreadsheetGoodies::Row.new(@header_row, index+1, self, *row)
      end

      self
    end

    # Reads a GoogleDrive::Spreadsheet object from Google Drive, using the
    # google_drive gem. Documentation for this class can be found here:
    # https://www.rubydoc.info/github/gimite/google-drive-ruby/GoogleDrive/Spreadsheet
    def underlying_adapter_worksheet
      @underlying_adapter_worksheet ||= Connector.new.read_worksheet(@spreadsheet_key, @worksheet_title)
    end
  end
end
