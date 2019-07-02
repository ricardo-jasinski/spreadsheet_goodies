require 'spec_helper'

describe SpreadsheetGoodies::Row do

  describe '#[]' do
    it 'retrieves an element via a numeric index' do
      row = SpreadsheetGoodies::Row.new([], 0, nil, 'a', 'b', 3)

      expect(row[0]).to eq 'a'
      expect(row[1]).to eq 'b'
      expect(row[2]).to eq 3
    end

    it 'retrieves an element via a column title' do
      column_titles = ['Employee', 'Salary']
      row = SpreadsheetGoodies::Row.new(column_titles, 0, nil, 'John', 10000.0)

      expect(row['Employee']).to eq 'John'
      expect(row['Salary']).to eq 10000.0
    end

    it 'raises an error if the column title does not exist' do
      column_titles = ['Employee', 'Salary']
      row = SpreadsheetGoodies::Row.new(column_titles, 0, nil, 'John', 10000.0)

      expect(row['Employee']).to eq 'John'
      expect { row['Age'] }.to raise_error "Column with title 'Age' does not exist in header row"
    end
  end

  describe '#[]=' do
    before do
      @sheet = double('Sheet')
      allow(@sheet).to receive(:write_to_cell)
    end

    it 'sets an element via a numeric index' do
      row = SpreadsheetGoodies::Row.new([], 0, @sheet)

      row[0] = 'a'
      row[1] = 'b'
      row[2] = 3

      expect(row[0]).to eq 'a'
      expect(row[1]).to eq 'b'
      expect(row[2]).to eq 3
    end

    it 'sets an element via a column title index' do
      column_titles = ['Employee', 'Salary']
      row = SpreadsheetGoodies::Row.new(column_titles, 0, @sheet)

      row['Employee'] = 'Smith'
      row['Salary'] = 5000.0

      expect(row['Employee']).to eq 'Smith'
      expect(row['Salary']).to eq 5000.0
    end

    it 'raises an error if the column title does not exist' do
      column_titles = ['Employee', 'Salary']
      row = SpreadsheetGoodies::Row.new(column_titles, 0, nil, 'John', 10000.0)

      expect {
        row['Age'] = 25
      }.to raise_error "Column with title 'Age' does not exist in header row"
    end
  end

end