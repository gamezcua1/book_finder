Gem::Specification.new do |s| 
  s.name = "book_finder"
  s.version = "0.0.3"
  s.date = "2019-10-30"
  s.summary = "A gem to find books on libgen and b-ok sites"
  s.authors = ["Gerald Amezcua", "Alejandro Zaizar"]
  s.email = ["gerald.amezcua@michelada.io", "alejandro.zaizar@michelada.io"]
  s.files = [ "Gemfile", "lib/book_finder.rb", "lib/bok.rb", "lib/libgen.rb"]
  s.require_paths = ["lib"]
  s.homepage = "https://github.com/gamezcua1/book_finder"
  s.license = "MIT"

  s.add_dependency "nokogiri", "~> 1.6"
end
