module SpreadsheetGoodies


  # Sobrecarrega método [] da Array para permitir acessar células passando
  # o título da coluna como índice. Ex: row['Data formal do pedido']
  class Row < Array
    attr_reader :header_row, :row_number, :parent_worksheet

    def initialize(header_row, sheet_row_number, parent_worksheet, *args)
      @header_row = header_row
      @row_number = sheet_row_number
      @parent_worksheet = parent_worksheet
      super(args)
    end

    def [](locator)
      cell_index = (locator.is_a?(String) ? @header_row.index(locator) : locator)

      # queries local cache only
      super(cell_index)
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
