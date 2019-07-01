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
          raise "Column with title #{locator} not found in header row"
        end
      else
        super(locator) # queries local cache only
      end
    end

    def []=(locator, value)
      cell_index = (locator.is_a?(String) ? @header_row.index(locator) : locator)

      # propagates change to real worksheet
      @parent_worksheet.write_to_cell(@row_number, cell_index+1, value)

      # updates local cache
      super(cell_index, value)
    end
  end
end
