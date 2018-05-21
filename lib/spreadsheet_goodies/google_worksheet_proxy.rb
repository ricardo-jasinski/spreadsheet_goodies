require_relative 'google_worksheet_proxy_row'
require 'csv'

# A cached copy of a Google Spreadsheets worksheet (i.e., a single workbook "tab"),
# stored as an array of arrays. Individual cells can be accessed by column title.
# Example:
#   worksheet[0]['A column title']
class SpreadsheetGoodies::GoogleWorksheetProxy
  attr_reader :rows, :header_row

  # @param worksheet_title_or_index [String] Sheet name; if unspecified, the
  #   first sheet will be used.
  # @param num_header_rows [Integer] Number of rows at the top of the sheet that
  #   contain headers or stuff other than data. Optional; if unspecified, assumes
  #   that a single top row contains the header and all rows below are data.
  def initialize(spreadsheet_key, worksheet_title=nil, num_header_rows=1)
    @spreadsheet_key = spreadsheet_key
    @worksheet_title = worksheet_title
    @num_header_rows = num_header_rows
  end

  # Reads sheet contents and caches it into instance variables to so that it
  # can be accessed later without accessing Google Drive.
  def read_from_google_drive
    worksheet_contents = read_worksheet.export_as_string.force_encoding('utf-8')

    rows = CSV::parse(worksheet_contents)
    @header_row = rows[@num_header_rows-1]
    @rows = rows.collect.with_index do |row, index|
      GoogleWorksheetProxyRow.new(@header_row, index+1, *row)
    end

    self
  end

  def [](index)
    @rows[index]
  end

  # Return only the rows that contain data (excludes the header rows)
  def data_rows
    @rows[@num_header_rows..-1]
  end

  # Finds and returns the first row that contains cell_value at the given column
  def find_row_by_column_value(column_title, cell_value)
    data_rows.each do |row|
      return row if row[column_title] == cell_value
    end

    nil
  end

  # Reads a GoogleDrive::Spreadsheet object from Google Drive. The sheet object
  # can be used to write data to the online spreadhseet, as we don't yet provide
  # the helper methods for our users to do it via our public interface.
  def read_worksheet
    connector = SpreadsheetGoodies::GoogleDriveConnector.new
    connector.read_worksheet(@spreadsheet_key, @worksheet_title)
  end
end