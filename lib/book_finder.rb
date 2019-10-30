require "bok"
require "libgen"

class BookFinder

  def initialize
    @libgen = Libgen.new
    @bok = Bok.new
  end

  def search(api: nil, params: {})
    return :PARAMS_MISSING if params.empty?

    if api == nil || api.downcase == "libgen"
      @result = @libgen.search(params)
    end

    if api == nil || api.downcase == "bok"
      @result = @bok.search(params)
    end

  end

end
