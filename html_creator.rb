require 'pry'
require 'nokogiri'

module HtmlCreator
  class Table
    def initialize(rows, columns)
      @rows = rows
      @columns = columns
      @width = nil
      @height = nil
      @header_classes = nil
      @body_classes = nil
      @border = nil
      @cellpadding = nil
      @header = []
      @data = []
    end

    def width(value)
      @width = value
    end

    def height(value)
      @height = value
    end

    def border(value)
      @border = value
    end

    def cellpadding(value)
      @cellpadding = value
    end

    def header_classes(value)
      @header_classes = value
    end

    def body_classes(value)
      @body_classes = value
    end

    def header(*args)
      @headers = args
    end

    def data(*args)
      @data << args
    end

    def table_init(table)
      table.set_attribute('width', @width) if @width
      table.set_attribute('height', @height) if @height
      table.set_attribute('border', @border) if @border
      table.set_attribute('cellpadding', @cellpadding) if @cellpadding
      table.set_attribute('class', @table_class) if @table_class
    end

    def header_init(doc, table_header_tr)
      @columns.times.each do |index|
        th         = doc.create_element('th')
        th.content = @headers[index]

        table_header_tr.add_child(th)
      end
    end

    def body_init(doc, table_body_tbody)
      @rows.times.each do |index|
        table_body = doc.create_element('tr')

        table_body.set_attribute('class', @body_classes) if @body_classes

        @columns.times.each do |column|
          td = doc.create_element('td')
          td.content = data[index][column]
          table_body.add_child(td)
        end

        table_body_tbody.add_child(table_body)
      end
    end

    def render
      html               = "<table></table>"
      doc                = Nokogiri::HTML(html)
      table              = doc.at('table')
      table_header_thead = doc.create_element('thead')
      table_body_tbody   = doc.create_element('tbody')
      table_header_tr    = doc.create_element('tr')

      table_init(table)
      header_init(doc, table_header_tr)
      body_init(doc, table_body_tbody)

      table_header_tr.set_attribute('class', @header_classes) if @header_classes

      table_header_thead.add_child(table_header_tr)
      table.add_child(table_header_thead)

      table.add_child(table_body_tbody)

      # puts table.to_html

      table.to_html
    end
  end

  def table(rows, columns, &block)
    table = Table.new(rows, columns)
    table.instance_eval(&block) if block_given?
    table.render
  end
end
