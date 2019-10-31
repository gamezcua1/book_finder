require_relative "bok"
require_relative "libgen"

class BookFinder

  def initialize
    @libgen = Libgen.new
    @bok = Bok.new
    @result = []
  end

  def search(api: nil, params: {})
    
    @result = []

    return :PARAMS_MISSING if params.empty?

    if api == nil || api.downcase == "libgen"
      @result += @libgen.search(params)
    end

    if api == nil || api.downcase == "bok"
      @result += @bok.search(params)
    end

    @result

  end

end
