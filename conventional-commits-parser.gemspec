Gem::Specification.new do |s|
  s.name = 'conventional-commits-parser'
  s.version = '1.0.0'
  s.date = '2020-06-03'
  s.summary = "Conventional Commits Parser"
  s.description = "Simple Ruby parser to turn a [Conventional Commit][0] into structured data."
  s.authors = ["John Pignata"]
  s.email = 'john@pignata.com'
  s.files = Dir.glob("{bin,lib}/**/*") + %w(README.md LICENSE)
  s.license = 'MIT'
end
