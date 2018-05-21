# SpreadsheetGoodies

SpreadsheetGoodies is a collection of tools to help work with spreadsheets in 
Excel and Google Spreadhseets formats. It relies heavily on other gems to make 
the actual work of reading and writing to spreadsheet documents. It main 
features are:

* Read a spreadseet as an array of arrays to allow aceessing its data without 
  using the original document
* Access a row's elements using the column titles as keys"

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spreadsheet_goodies'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spreadsheet_goodies

## Usage

To read a Google Spreadsheet:
```
spreadsheet_key = '1UC43X6aZwlWPCnn...'
sheet = SpreadsheetGoodies::GoogleWorksheetProxy.new(spreadsheet_key, 'Relação Lojas').read_from_google_drive
```

To read an Excel workbook:
```
sheet = SpreadsheetGoodies::ExcelWorksheetProxy.new('~/workbook.xlsx')
```

Iterate over every data row (i.e., allbut the header row) and print the value of
the 'Total' column: 
```
sheet.data_rows.each do |row|
  puts "#{row.row_number} -- #{row['Total']}"
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ricardo-jasinski/spreadsheet_goodies.


## License

The gem is available as open source under the terms of the [Unlicense](http://unlicense.org/UNLICENSE).

