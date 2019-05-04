require 'axlsx'

# A set of methods to help create and format Excel workbooks
module SpreadsheetGoodies::Excel
  class WorkbookBuilder
    attr_reader :current_sheet

    def initialize(output_file_pathname)
      @output_file_pathname = output_file_pathname
      @axlsx_package = Axlsx::Package.new
    end

    # The underlying Axlsx::Workbook object
    def workbook
      @axlsx_package.workbook
    end

    def add_worksheet(sheet_name)
      @current_sheet = workbook.add_worksheet(name: sheet_name)
      setup_current_sheet_styles
      freeze_top_row
      @current_sheet
    end

    # Add a row to the current sheet using the data row style
    def add_data_row(row_values)
      @current_sheet.add_row(row_values, style: @data_row_style)
    end

    # Add a row to the current sheet using the header row style
    def add_header_row(row_values)
      @current_sheet.add_row(row_values, style: @header_row_style)
    end

    # Add filter and sorting controls to a sheet.
    def setup_auto_filter(sheet=nil)
      worksheet = sheet || @current_sheet
      top_left_cell_label = worksheet.dimension.first_cell_reference
      bottom_right_cell_label = worksheet.dimension.last_cell_reference
      filter_range = "#{top_left_cell_label}:#{bottom_right_cell_label}"
      worksheet.auto_filter = filter_range
    end

    def write_to_file
      @axlsx_package.serialize(@output_file_pathname)
    end

    def freeze_top_row
      @current_sheet.sheet_view.pane do |pane|
        pane.top_left_cell = 'A2'
        pane.state = :frozen_split
        pane.y_split = 1
        pane.active_pane = :bottom_right
      end
    end

  private

    def setup_current_sheet_styles
      @header_row_style = @current_sheet.styles.add_style(
        alignment: {horizontal: :center, vertical: :center},
        font_name: 'Calibri',
        bg_color: 'FFDDDDDD',
        b: true,
      )

      @header_row_sodexo_style = @current_sheet.styles.add_style(
        alignment: {horizontal: :center, vertical: :center},
        font_name: 'Calibri',
        bg_color: '002060',
        fg_color: 'FFFFFF',
        b: true,
      )

      @data_row_style = @current_sheet.styles.add_style(
        font_name: 'Calibri',
      )
    end
  end
end
