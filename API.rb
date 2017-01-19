require File.dirname(__FILE__) + '/../Plugin.rb'
require File.dirname(__FILE__) + '/DeckIdentifier.rb'
require File.dirname(__FILE__) + '/../../YgorubyBase/Deck.rb'
require File.dirname(__FILE__) + '/Compiler.rb'
require File.dirname(__FILE__) + '/GitSyncer.rb'

Ygoruby::Plugins.apis.push 'get', '/deckIdentifier/json' do
	json    = request.body.read
	deck    = Deck.from_hash json
	content = DeckIdentifier.global[deck]
	content_type 'application/json'
	content.to_json
end


# 这些是为服务器前端设计的 API。
# 不需要前端维护的场合，这些 API 可以移除。
## 测试环境
test_environment = DeckIdentifier.new 'test'

Ygoruby::Plugins.apis.push 'post', '/deckIdentifier/test/compiler' do
	halt 403 unless DeckIdentifier.check_access_key params['accesskey']
	def_str = request.body.read
	def_str.force_encoding 'utf-8'
	content = DeckIdentifierCompiler.new.compile_str def_str
	content_type 'application/json'
	content.to_json
end

Ygoruby::Plugins.apis.push 'post', '/deckIdentifier/test/compiler/heavy' do
	# halt 403 unless DeckIdentifier.check_access_key params['accesskey']
	def_str = request.body.read
	def_str.force_encoding 'utf-8'
	obj = DeckIdentifierCompiler.new.compile_str def_str
	content = test_environment.classificationize obj
	content_type 'application/json'
	content.to_json
end

Ygoruby::Plugins.apis.push 'post', '/deckIdentifier/test' do
	halt 403 unless DeckIdentifier.check_access_key params['accesskey']
	json    = request.body.read
	content = JSON.parse json
	test_environment.register content
	'finished'
end

Ygoruby::Plugins.apis.push 'delete', '/deckIdentifier/test' do
	halt 403 unless DeckIdentifier.check_access_key params['accesskey']
	test_environment.clear
	'cleared'
end

Ygoruby::Plugins.apis.push 'post', '/deckIdentifier/test/test' do
	halt 403 unless DeckIdentifier.check_access_key params['accesskey']
	json    = request.body.read
	deck    = Deck.from_hash json
	content = test_environment[deck]
	content_type 'application/json'
	content.to_json
end

Ygoruby::Plugins.apis.push 'post', '/deckIdentifier/test/load' do
	halt 403 unless DeckIdentifier.check_access_key params['accesskey']
	test_environment.register_config
	test_environment.finish
	'loaded'
end

Ygoruby::Plugins.apis.push 'post', '/deckIdentifier/test/reset' do
	halt 403 unless DeckIdentifier.check_access_key params['accesskey']
	test_environment.clear
	test_environment.register_config
	test_environment.finish
	'reset'
end


## 工作环境
Ygoruby::Plugins.apis.push 'get', '/deckIdentifier/product/list' do
	halt 403 unless DeckIdentifier.check_access_key params['accesskey']
	content_type 'application/json'
	DeckIdentifier.get_config_file_list.to_json
end

Ygoruby::Plugins.apis.push 'get', '/deckIdentifier/product' do
	halt 403 unless DeckIdentifier.check_access_key params['accesskey']
	DeckIdentifier.get_config_file params['filename'] + '.deckdef'
end

Ygoruby::Plugins.apis.push 'post', '/deckIdentifier/product' do
	halt 403 unless DeckIdentifier.check_access_key params['accesskey']
	DeckIdentifier.save_config_file_to params['filename'] + '.deckdef', params['file']
	'posted'
end

Ygoruby::Plugins.apis.push 'delete', '/deckIdentifier/product' do
	halt 403 unless DeckIdentifier.check_access_key params['accesskey']
	DeckIdentifier.remove_config_file params['filename']
	'removed'
end

Ygoruby::Plugins.apis.push 'post', '/deckIdentifier/restart' do
	halt 403 unless DeckIdentifier.check_access_key params['accesskey']
	DeckIdentifier.global.clear
	DeckIdentifier.global.register_config
	'restart'
end

## Git 操作
Ygoruby::Plugins.apis.push 'post', '/deckIdentifier/git/pull' do
	halt 403 unless DeckIdentifier.check_access_key params['accesskey']
	GitSyncer.pull
	'fin'
end

Ygoruby::Plugins.apis.push 'post', '/deckIdentifier/git/push' do
	halt 403 unless DeckIdentifier.check_access_key params['accesskey']
	GitSyncer.push
	'fin'
end

