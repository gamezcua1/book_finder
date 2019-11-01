require "nokogiri"
require "open-uri"

module BookFinder
  class Libgen
    attr_accessor :columns, :row
    attr_writer :books

    BASE_URL = "http://gen.lib.rus.ec/search.php".freeze

    def search(params)

      query, by, ordered_by, order_mode, page = params.values

      return :QUERY_MISSING unless query

      url = BASE_URL + "?req=#{query}"
      url << "&sort=#{ordered_by}" if ordered_by
      url << "&sortmode=#{order_mode}" if order_mode
      url << "&column=#{by}" if by
      url << "&page=#{page}" if page

      html = URI.parse(url).open
      @doc = Nokogiri::HTML(html)

      initialize_columns
      initialize_rows
      books
    end

    def books
      @books = @rows.map { |r|
        @columns.zip(vals(r)).to_h
      }
    end

    private

    def initialize_columns
      dom_cols = @doc.search('[@bgcolor="#C0C0C0"]').first.children
      @columns = dom_cols.map { |col|
        col.content.strip.downcase.tr("()", "") unless col.content.strip.empty?
      }

      @columns.compact!
      @columns.shift
      @columns.pop
    end

    def vals(row)
      full_vals = []
      vals = row.content.split("\r\n\t\t\t\t")
      vals.pop
      vals.shift

      authors = vals.shift.split(",")
      a_authors = row
        .children[2]
        .search("a")
        .map { |a| a.attribute("href").to_s }
      full_vals << authors.zip(a_authors).to_h

      7.times { full_vals << vals.shift }

      full_vals << row.children[18..22].search("a").map { |a| a.attribute("href").to_s }
      full_vals
    end

    def initialize_rows
      @rows = [@doc.search('[@bgcolor="#C6DEFF"]'),
               @doc.search('[@bgcolor=""]'),].flatten
    end
  end
end
