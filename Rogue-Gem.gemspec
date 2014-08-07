require 'rubygems'

spec = Gem::Specification.new do |s| 
	s.name = "Rogue-Gem"
	s.version = "0.0.1"
	s.summary = "Rogue-Gem provides methods that simplify Windows Roguelike game development."
	s.files = Dir.glob("**/**/**")
	s.test_files == ("test/*_test.rb")
	s.author = "bg42"
	s.email = ""
	s.has_rdoc = true
end 