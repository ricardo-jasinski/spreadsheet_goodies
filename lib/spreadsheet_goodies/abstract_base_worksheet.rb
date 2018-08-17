
# Base class for all worksheets
module SpreadsheetGoodies
  class AbstractBaseWorksheet
    attr_reader :rows, :header_row

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

    # Writes to a given cell identified by row and column indexes (they start at 1)
    # This method should be overriden by worksheets that wish to implement writes.
    # Usually this method is not called directly by the gem user, but rather from
    # the modified row itself
    def write_to_cell(row_index, col_index, value)
      raise 'writes are not implemented for this type of worksheet'
    end

    # Some adapters (like GoogleDrive) require writes to be committed to actually
    # make the changes on the spreadsheet
    def commit_writes!
      raise 'this kind of worksheet does not require writes to be committed'
    end
  end
end
