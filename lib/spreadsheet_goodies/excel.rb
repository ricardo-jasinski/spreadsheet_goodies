
module SpreadsheetGoodies::Excel

  def self.read_worksheet(file_pathname:, worksheet_title_or_index:0, num_header_rows:1)
    Worksheet.new(file_pathname, worksheet_title_or_index, num_header_rows)
  end

end

# loads all files in excel folder
Dir[File.join(File.dirname(__FILE__), "excel/**/*.rb")].each { |f| require f }
