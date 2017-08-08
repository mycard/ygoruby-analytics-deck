require File.dirname(__FILE__) + '/../../Log.rb'
require File.dirname(__FILE__) + '/../Plugin.rb'
require File.dirname(__FILE__) + '/DeckIdentifier.rb'
require File.dirname(__FILE__) + '/../../YgorubyBase/Deck.rb'
require File.dirname(__FILE__) + '/Compiler.rb'
require File.dirname(__FILE__) + '/GitSyncer.rb'

def base_logger
	return logger
end

Plugin.api.push 'get', '/analyze/deckIdentifier/json' do
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

Plugin.api.push 'post', '/analyze/deckIdentifier/test/compiler' do
	DeckIdentifier.quick_access_key params['accesskey'], self, ' compiled a string file.'
	def_str = request.body.read
	def_str.force_encoding 'utf-8'
	content = DeckIdentifierCompiler.new.compile_str def_str
	content_type 'application/json'
	content.to_json
end

Plugin.api.push 'post', '/analyze/deckIdentifier/test/compiler/heavy' do
	DeckIdentifier.quick_access_key params['accesskey'], self, ' compiled a string file and classificationized it.'
	def_str = request.body.read
	def_str.force_encoding 'utf-8'
	obj     = DeckIdentifierCompiler.new.compile_str def_str
	content = test_environment.classificationize obj
	content_type 'application/json'
	content.to_json
end

Plugin.api.push 'post', '/analyze/deckIdentifier/test/compiler/full' do
	DeckIdentifier.quick_access_key params['accesskey'], self, ' compiled a string file and added it.'
	def_str = request.body.read
	def_str.force_encoding 'utf-8'
	obj     = DeckIdentifierCompiler.new.compile_str def_str
	content = test_environment.classificationize obj
	test_environment.register content
	test_environment.finish
	content_type 'application/json'
	content.to_json
end

Plugin.api.push 'post', '/analyze/deckIdentifier/test' do
	DeckIdentifier.quick_access_key params['accesskey'], self, ' posted a string file into the test environment.'
	json    = request.body.read
	content = JSON.parse json
	test_environment.register test_environment.classificationize DeckIdentifierCompiler.new.compile_str content
	'finished'
end

Plugin.api.push 'delete', '/deckIdentifier/test' do
	DeckIdentifier.quick_access_key params['accesskey'], self, ' requested to clear the test environment.'
	test_environment.clear
	'cleared'
end

Plugin.api.push 'post', '/analyze/deckIdentifier/test/test' do
	DeckIdentifier.quick_access_key params['accesskey'], self, ' request to test a deck.'
	content = request.body.read
	deck    = Deck.load_ydk_str content
	content = test_environment[deck]
	content_type 'application/json'
	content.to_json
end

Plugin.api.push 'post', '/analyze/deckIdentifier/test/load' do
	DeckIdentifier.quick_access_key params['accesskey'], self, ' requested to import production into test environment.'
	test_environment.clear
	test_environment.register_config
	test_environment.finish
	'loaded'
end

Plugin.api.push 'post', '/analyze/deckIdentifier/test/reset' do
	DeckIdentifier.quick_access_key params['accesskey'], self, 'reset the test environment.'
  messages = ''
	base_logger.register_trigger 'test' + params['accesskey'] do |message, line|
    messages += line
  end
	test_environment.clear
	test_environment.register_config
	test_environment.finish
	base_logger.unregister_trigger 'test' + params['accesskey']
	"reset\n" + messages
end


## 工作环境
Plugin.api.push 'get', '/analyze/deckIdentifier/product/list' do
	DeckIdentifier.quick_access_key params['accesskey'], self, 'requested the file list.'
	content_type 'application/json'
	DeckIdentifier.get_config_file_list.to_json
end

Plugin.api.push 'get', '/analyze/deckIdentifier/product' do
	DeckIdentifier.quick_access_key params['accesskey'], self, 'requested the file ' + params['filename']
	DeckIdentifier.get_config_file params['filename'] + '.deckdef'
end

Plugin.api.push 'post', '/analyze/deckIdentifier/product' do
	DeckIdentifier.quick_access_key params['accesskey'], self, 'posted the file ' + params['filename']
	DeckIdentifier.save_config_file_to params['filename'] + '.deckdef', params['file']
	'posted'
end

Plugin.api.push 'delete', '/analyze/deckIdentifier/product' do
	DeckIdentifier.quick_access_key params['accesskey'], self, 'removed the file ' + params['filename']
	DeckIdentifier.remove_config_file params['filename']
	'removed'
end

Plugin.api.push 'post', '/analyze/deckIdentifier/restart' do
	DeckIdentifier.quick_access_key params['accesskey'], self, 'restarted the production server config.'
  messages = ""
	base_logger.register_trigger 'production' + params['accesskey'] do |msg, line|
    messages += line
  end
	DeckIdentifier.global.clear
	DeckIdentifier.global.register_config
	DeckIdentifier.global.finish
	base_logger.unregister_trigger 'production' + params['accesskey']
	"restart\n" + messages
end

## 记录管理
$mysterious_records = nil
Plugin.api.push 'get', '/analyze/deckIdentifier/record/next' do
	DeckIdentifier.quick_access_key params['accesskey'], self, 'checked next record.'
	$mysterious_records = Dir.glob 'mysterious_decks/*.ydk' if $mysterious_records == nil
	deck_path = $mysterious_records.pop
	if deck_path == nil
		''
	else
		content = File.open(deck_path) { |f| f.read }
		File.delete deck_path
		content_type 'application/json'
		{ name: deck_path, content: content, remain: $mysterious_records.count }.to_json
	end
end

Plugin.api.push 'get', '/analyze/deckIdentifier/record/reset' do
	DeckIdentifier.quick_access_key params['accesskey'], self, 'reset the record pointer.'
	$mysterious_records = nil
	'reset the record pointer.'
end

Plugin.api.push 'get', '/analyze/deckIdentifier/record/clear' do
	DeckIdentifier.quick_access_key params['accesskey'], self, 'clear the record dir.'
	$mysterious_records = nil
	list = Dir.glob('mysterious_decks/*.ydk')
	list.each { |file| File.delete file }
	"removed #{list.count} records"
end

## Git 操作
Plugin.api.push 'post', '/analyze/deckIdentifier/git/pull' do
	DeckIdentifier.quick_access_key params['accesskey'], self, 'pulled from git.'
	answer = GitSyncer.pull
	"fin\n" + answer
end

Plugin.api.push 'post', '/analyze/deckIdentifier/git/push' do
	DeckIdentifier.quick_access_key params['accesskey'], self, 'pushed to the git.'
	answer = GitSyncer.push
	"fin\n" + answer
end

# 静态页面
Plugin.api.push 'static', { ['/analyze/deckIdentifier/console/'] => 'Plugins/DeckIdentifier/Server/'} do
end