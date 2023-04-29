require_relative 'html_creator'
require 'nokogiri'

describe HtmlCreator do
  include HtmlCreator

  it 'creates a table with headers and data' do
    expected_html = "<table>\n<thead><tr>\n<th>Header 1</th>\n<th>Header 2</th>\n</tr></thead>\n<tbody>\n<tr>\n<td>Row 1, Cell 1</td>\n<td>Row 1, Cell 2</td>\n</tr>\n<tr>\n<td>Row 2, Cell 1</td>\n<td>Row 2, Cell 2</td>\n</tr>\n</tbody>\n</table>"

    html = table(2, 2) do
      header 'Header 1', 'Header 2'
      data 'Row 1, Cell 1', 'Row 1, Cell 2'
      data 'Row 2, Cell 1', 'Row 2, Cell 2'
    end

    expect(html).to eq(expected_html)
  end

  it 'creates a table with width and height' do
    expected_html = "<table width=\"100%\" height=\"200px\">\n<thead><tr>\n<th>Header 1</th>\n<th>Header 2</th>\n</tr></thead>\n<tbody>\n<tr>\n<td>Row 1, Cell 1</td>\n<td>Row 1, Cell 2</td>\n</tr>\n<tr>\n<td>Row 2, Cell 1</td>\n<td>Row 2, Cell 2</td>\n</tr>\n</tbody>\n</table>"

    html = table(2, 2) do
      width '100%'
      height '200px'
      header 'Header 1', 'Header 2'
      data 'Row 1, Cell 1', 'Row 1, Cell 2'
      data 'Row 2, Cell 1', 'Row 2, Cell 2'
    end

    expect(html).to eq(expected_html)
  end

  it 'creates a table with border and cellpadding' do
    expected_html = "<table width=\"100%\" height=\"200px\" border=\"1\" cellpadding=\"5\">\n<thead><tr class=\"header_classes\">\n<th>Header 1</th>\n<th>Header 2</th>\n</tr></thead>\n<tbody>\n<tr class=\"boby_classes\">\n<td>Row 1, Cell 1</td>\n<td>Row 1, Cell 2</td>\n</tr>\n<tr class=\"boby_classes\">\n<td>Row 2, Cell 1</td>\n<td>Row 2, Cell 2</td>\n</tr>\n</tbody>\n</table>"

    html = table(2, 2) do
      width '100%'
      height '200px'
      border 1
      cellpadding 5
      header_classes 'header_classes'
      body_classes 'boby_classes'
      header 'Header 1', 'Header 2'
      data 'Row 1, Cell 1', 'Row 1, Cell 2'
      data 'Row 2, Cell 1', 'Row 2, Cell 2'
    end

    expect(html).to eq(expected_html)
  end

  it 'checks correct size of rows and columns' do
    html = table(3, 2) do
      width '100%'
      height '200px'
      border 1
      cellpadding 5
      header_classes 'header_classes'
      body_classes 'boby_classes'
      header 'Header 1', 'Header 2'
      data 'Row 1, Cell 1', 'Row 1, Cell 2'
      data 'Row 2, Cell 1', 'Row 2, Cell 2'
    end

    parsed_html = Nokogiri::HTML.parse(html)
    thead       = parsed_html.at('thead')
    tbody       = parsed_html.at('tbody')

    expect(tbody.search('tr').count).to eq(3)
    expect(thead.search('tr').count).to eq(1)
    expect(thead.search('th').count).to eq(2)
  end
end
