require_relative 'excel_worksheet_proxy_row'

# A cached copy of an Excel worksheet (a single workbook "tab"), stored as an
# array of arrays. Individual cells can be accessed by column title, e.g.:
#   worksheet[0]['A column title']
class SpreadsheetGoodies::ExcelWorksheetProxy
  attr_reader :rows, :workbook, :worksheet

  # @param workbook_file_pathname [String] Full path and filename to Excel workbook document
  # @param worksheet_title_or_index [String|Integer] Sheet name or index (zero-based)
  #   within the workbook. Optional; if unspecified, the first sheet will be used.
  # @param num_header_rows [Integer] Number of rows at the top of the sheet that
  #   contain headers or stuff other than data. Optional; if unspecified, assumes
  #   that a single top row contains the header and all rows below are data.
  def initialize(workbook_file_pathname, worksheet_title_or_index=0, num_header_rows=1)
    @worksheet_title = worksheet_title_or_index
    @num_header_rows = num_header_rows

    @workbook = case workbook_file_pathname
    when /\.xls(\.\d+)?$/ then Roo::Excel.new(workbook_file_pathname, file_warning: :ignore)
    when /\.xlsx(\.\d+)?$/ then Roo::Excelx.new(workbook_file_pathname, file_warning: :ignore)
    end

    @worksheet = @workbook.sheet(worksheet_title_or_index)

    @header_row = @worksheet.row(num_header_rows)

    # Reads all the worksheet rows, one at a time, using Workshete#row (note: reading
    # them all at once using Worksheet#parse didn't work because the first row
    # was missed some times.)
    rows = (1..@worksheet.last_row).map {|row_number| @worksheet.row(row_number) }

    # Create the rows cache, made of instances of ExcelWorksheetProxyRow
    @rows = rows.collect.with_index do |row, index|
      ExcelWorksheetProxyRow.new(@header_row, index+1, *row)
    end
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

  def add_row(row_data)
    @rows << CachedExcelWorksheetRow.new(@header_row, *row_data)
  end

  def spreadsheet
    @workbook
  end

end
