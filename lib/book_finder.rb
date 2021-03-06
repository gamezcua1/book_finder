require_relative "bok"
require_relative "libgen"

module BookFinder
  @libgen = BookFinder::Libgen.new
  @bok = BookFinder::Bok.new
  @result = []
 
  def self.search(api: nil, params: {})
    @result = []

    return :PARAMS_MISSING if params.empty?

    if api.nil? || api.downcase == "libgen"
      @result += @libgen.search(params)
    end

    if api.nil? || api.downcase == "bok"
      @result += @bok.search(params)
    end

    @result = @result.map do |book|
      book.map { |key, value| [key.to_s.downcase.chomp, value.to_s.downcase.chomp] }.to_h
    end

    @result.uniq { |book| {authors: book["authors"], title: book["title"], year: book["year"], language: book["language"], size: book["size"], extension: book["extension"]} }

  end

end

# books = BookFinder.search(params:{query:"dog"})
# puts books.length
# puts books.shift, books.pop
# puts "------"
# p books
