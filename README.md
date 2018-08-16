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

Read a Google Spreadsheet:
```ruby
sheet = SpreadsheetGoodies::GoogleDrive.read_worksheet(
  spreadsheet_key: '1UC43X6aZwlWPCnn...', # required,
  worksheet_title: 'sheet1', # optional, first worksheet is loaded if not specified
)
```

Read an Excel workbook:
```ruby
sheet = SpreadsheetGoodies::Excel.read_worksheet(
  file_pathname: '~/workbook.xlsx', # required,
  worksheet_title_or_index: 'sheet1', # optional, first worksheet is loaded if not specified
)
```

Iterate over every data row (i.e., all but the header row) and print the value
of a column titled 'Total':
```ruby
sheet.data_rows.each do |row|
  puts "#{row.row_number} -- #{row['Total']}"
end
```

Writing values to cells (only available for GoogleDrive adapter right now):
```ruby
row = sheet[0]
row[0] = 'First cell'
row[1] = 'Second cell'
sheet.commit_writes! # changes are applied to real spreadsheet
```

## Logging in to Google Drive
If you need to access a spreadsheet on Google Drive that is not publicly accessible,
you are required to setup an authentication method. Currently, there are two available
authentication methods.

### OAuth2
To setup OAuth2, first you must configure your Google client id and a client secret
like the example below. If you don't have a client id yet, you must create a project
and enable the GoogleDrive API at https://console.developers.google.com. Then you
need to create a OAuth client id.
```ruby
SpreadsheetGoodies.configure do |config|
  config.login_method = :oauth2
  config.google_client_id = '1012345678904-fdks82jfhe8ojdks7285fj4pnqiejrnbt.apps.googleusercontent.com' # put your real client id here
  config.client_secret = 'Aa-Ku8C-askjfAYKkdjf9ssnf' # put your real secret here
end
```

Then run your code. You will be prompted to make the authorization process to obtain
a refresh token:
```
1. Open this page:
https://accounts.google.com/o/oauth2/auth?access_type=offline&client_id=1012345678904-fdks82jfhe8ojdks7285fj4pnqiejrnbt.apps.googleusercontent.com&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&scope=https://www.googleapis.com/auth/drive%20https://spreadsheets.google.com/feeds/

2. Enter the authorization code shown in the page: 4/LADQHhpk7x27BMeP2tIEe_pKuTJmJmZhWoRcBhBmFTVRqSEtcap7Z6s

Congratulations! Your refresh token is: 1/c9JDKAUF83_4SPqNc8ldQWe9TdXOxqXvMJJPtmDA2k
Set the refresh_token in your SpreadsheetGoodies configuration and run your code again
```

### Service Accounts
```ruby
SpreadsheetGoodies.configure do |config|
  config.login_method = :service_account
  config.service_account_key_json = '...'
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ricardo-jasinski/spreadsheet_goodies.


## License

The gem is available as open source under the terms of the [Unlicense](http://unlicense.org/UNLICENSE).
