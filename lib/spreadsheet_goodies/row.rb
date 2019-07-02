module SpreadsheetGoodies

  # Override Array#[] and Array#[]= to allow indexing by the column title.
  # E.g.: row['Employee name']
  class Row < Array
    attr_reader :header_row, :row_number, :parent_worksheet

    def initialize(header_row, sheet_row_number, parent_worksheet, *args)
      @header_row = header_row
      @row_number = sheet_row_number
      @parent_worksheet = parent_worksheet
      super(args)
    end

    def [](locator)
      if locator.is_a?(String)
        if column_index = @header_row.find_index(locator)
          super(column_index) # queries local cache only
        else
          raise "Column with title '#{locator}' does not exist in header row"
        end
      else
        super(locator) # queries local cache only
      end
    end

    def []=(locator, value)
      if locator.is_a?(String)
        column_index = @header_row.find_index(locator)
        if column_index.nil?
          raise "Column with title '#{locator}' does not exist in header row"
        end
      else
        column_index = locator
      end

      # propagates change to real worksheet
      @parent_worksheet.write_to_cell(@row_number, column_index+1, value)

      # updates local cache
      super(column_index, value)
    end
  end
end
