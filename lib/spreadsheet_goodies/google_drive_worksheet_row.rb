class SpreadsheetGoodies::GoogleDriveWorksheet

  # Sobrecarrega método [] da Array para permitir acessar células passando
  # o título da coluna como índice. Ex: row['Data formal do pedido']
  class ::GoogleDriveWorksheetRow < Array
    attr_reader :header_row, :row_number

    def initialize(header_row, sheet_row_number, *args)
      @header_row = header_row
      @row_number = sheet_row_number
      super(args)
    end

    def [](locator)
      if locator.is_a?(String)
        return self[ @header_row.index(locator) ]
      else
        return super(locator)
      end
    end
  end

end