class SpreadsheetGoodies::ExcelWorksheet

  # Overload Array#[] to allow reading a cell's contents using its column title
  # as index, e.g.: row['Column Title']
  class ::ExcelWorksheetRow < Array
    attr_reader :header_row, :row_number

    # @param header_row [Array] The header cells of the sheet from were the row was taken
    # @param sheet_row_number [Integer] The original row number of the row in the
    #   sheet from where the row was taken. Row numebrs follow the spreadshet convention,
    #   i.e., starting from 1.
    def initialize(header_row, sheet_row_number, *args)
      @header_row = header_row
      @row_number = sheet_row_number
      super(args)
    end

    # @param locator [Integer|String] The index of a row element. Can be a string
    #   (a column title) or an integer (starting at 0 for the first cell).
    # @return [String]
    def [](locator)
      if locator.is_a?(String)
        return self[ @header_row.index(locator) ]
      else
        return super(locator)
      end
    end
  end

end