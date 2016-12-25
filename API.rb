require File.dirname(__FILE__) + '/../Plugin.rb'
require File.dirname(__FILE__) + '/DeckIdentifier.rb'
require File.dirname(__FILE__) + '/../../YgorubyBase/Deck.rb'
require File.dirname(__FILE__) + '/Compiler.rb'

Ygoruby::Plugins.apis.push 'get', '/deckIdentifier/json' do
	json    = request.body.read
	deck    = Deck.from_hash json
	content = DeckIdentifier.global[deck]
	content_type 'application/json'
	content.to_json
end

# 前端测试用
test_environment = DeckIdentifier.new 'test'

Ygoruby::Plugins.apis.push 'post', '/deckIdentifier/test/compiler' do
	def_str = request.body.read
	def_str.force_encoding 'utf-8'
	content = DeckDefinitionCompiler.new.compile_str def_str
	content_type 'application/json'
	content.to_json
end

Ygoruby::Plugins.apis.push 'push', '/deckIdentifier/test' do
	json    = request.body.read
	content = JSON.parse json
	test_environment.register content
	'finished'
end

Ygoruby::Plugins.apis.push 'delete', '/deckIdentifier/test' do
	'cleared'
end

Ygoruby::Plugins.apis.push 'post', '/deckIdentifier/test' do
	json    = request.body.read
	deck    = Deck.from_hash json
	content = test_environment[deck]
	content_type 'application/json'
	content.to_json
end

Ygoruby::Plugins.apis.push 'post', '/deckIdentifier/test/load' do
	test_environment.register_config
	test_environment.finish
	'loaded'
end