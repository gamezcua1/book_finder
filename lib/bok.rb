# frozen_string_literal: true

require "nokogiri"
require "open-uri"

# b-ok api interface for simple use with web scrapping
class Bok
  BASEURL = "https://b-ok.cc"

  def initialize
    @page = 1
    @img_by_book = []
    @title_by_book = []
    @links_by_book = []
    @authors_by_book = []
    @year_by_book = []
    @language_by_book = []
    @extension_by_book = []
    @size_by_book = []
  end

  def search(query:, page: 1, from: nil, to: nil, language: nil, order_by: nil)
    # https://b-ok.cc/s/?q=ruby&yearFrom=2018&yearTo=2019&language=english&order=year
    @page = page
    url = BASEURL + "/s/?q=#{query}&page=#{page}"
    if from && to
      url += "&yearFrom=#{from}&yearTo=#{to}"
    end
    if language
      url += "&language=#{language}"
    end
    if order_by
      url += "&order=#{order_by}"
    end
    html = URI.parse(url).open
    @doc = Nokogiri::HTML(html)
    run
    structure
  end

  private

  def run
    img_urls
    book_titles
    book_authors
    book_year
    book_language
    book_file
  end

  def structure
    books = []
    @img_by_book.zip(
      @title_by_book,
      @links_by_book,
      @authors_by_book,
      @year_by_book,
      @language_by_book,
      @extension_by_book,
      @size_by_book
    ).each do |book|
      books.push(
        img: book[0],
        title: book[1],
        link: book[2],
        authors: book[3],
        year: book[4],
        language: book[5],
        extension: book[6],
        size: book[7]
      )
    end
    books
  end

  def imgurls
    @doc.search("img.cover.lazy").each do |node|
      @img_by_book.push("https:" + node["data-src"].to_s)
    end
  end

  def book_titles
    @doc.search('[@itemprop="name"] a').each do |node|
      @title_by_book.push(node.text.to_s)
      url = BASEURL.to_s + node["href"].to_s
      doc = Nokogiri::HTML(URI.parse(url).open)
      doc.search("a.dlButton").each do |nodes|
        @links_by_book.push(BASEURL.to_s + nodes["href"].to_s)
      end
    end
  end

  def book_authors
    @doc.search('[@class="authors"]').each do |node|
      authors = {}
      node.search("a").each do |author|
        authors[author.text.to_s] = (BASEURL.to_s + author["href"].to_s)
      end
      @authors_by_book.push(authors)
    end
  end

  def book_year
    @doc.search("div.bookProperty.property_year").each do |node|
      @year_by_book.push(node.text.to_s.gsub!(/\s+/, "").gsub!(/\w+:/, ""))
    end
  end

  def book_language
    @doc.search("div.bookProperty.property_language").each do |node|
      @language_by_book.push(node.text.to_s.gsub!(/\s+/, "").gsub!(/\w+:/, ""))
    end
  end

  def book_file
    @doc.search("div.bookProperty.property__file").each do |node|
      extension, size = node.text.to_s.gsub!(/\s+/, "")
        .gsub!(/\w+:/, "").split(",")
      @extension_by_book.push(extension)
      @size_by_book.push(size)
    end
  end
end
