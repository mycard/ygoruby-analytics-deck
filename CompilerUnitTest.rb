require './Compiler.rb'
require 'json'

logger.config.log_level = :debug

def test1
	compiler = DeckIdentifierCompiler.new
	obj = compiler.compile_file File.open 'Definition/FullStatementSample.deckdef'
	print JSON.pretty_generate obj
end

def test2
	compiler = DeckIdentifierCompiler.new
	obj = compiler.compile_file File.open 'Definition/#PedulumSets-example.deckdef'
	print JSON.pretty_generate obj
end

test2