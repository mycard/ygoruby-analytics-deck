require File.dirname(__FILE__) + '/DeckType.rb'
require File.dirname(__FILE__) + '/Tag.rb'
require File.dirname(__FILE__) + '/Compiler.rb'

class DeckIdentifier
	attr_accessor :environment_name
	
	def initialize(name = 'mysterious')
		@tags             = []
		@global_tags      = []
		@decks            = []
		@environment_name = name
	end
	
	def register(obj)
		if obj.is_a? Array
			logger.info "#{environment_name} Loaded #{obj.count} definitions."
			obj.each { |child| register child }
		elsif obj.is_a? DeckType
			logger.info "#{environment_name} Loaded 1 deck definition: #{obj.name}"
			@decks.push obj
		elsif obj.is_a? Tag
			logger.info "#{environment_name} Loaded 1 tag definition: #{obj.name}"
			@tags.push obj
			if obj.is_global?
				@global_tags.push obj
			end
		end
	end
	
	def register_dir(dir_path)
		files = Dir.glob File.join dir_path, '*.*'
		files.each { |file| self.register_file file }
	end
	
	def register_config
		config = $config[File.dirname __FILE__]['Definitions']
		config = [config] if config.is_a? String
		config = [] unless config.is_a? Array
		config.each { |path| register_dir path }
	end
	
	def register_file(file_path)
		basename = File.basename file_path
		extname  = File.extname file_path
		if basename.start_with? '#'
			logger.info "ignored loading file #{basename}"
			return
		end
		logger.info "Identifier #{@environment_name} is loading file #{basename}"
		case extname
			when '.json'
				str = File.open(file_path).read
				self.register_json_str str
			when '.yaml'
				str = File.open(file_path).read
				self.register_yaml_str str
			when '.deckdef'
				self.register_deckdef_file File.open file_path
			when '.rb'
				logger.warn "not supported now for ruby definition #{basename}"
				self.register_rb_file str
			else
				logger.warn "can't recognize file #{file_path}"
		end
	end
	
	def register_rb_file(file)
		# not supported now
	end
	
	def register_yaml_str(str)
		require 'yaml'
		root = YAML.load str
		register root
	end
	
	def register_json_str(str)
		require 'json'
		root = JSON.parse str
		register root
	end
	
	def register_deckdef_file(file)
		root = DeckIdentifierCompiler.new.compile_file file
		register root
	end
	
	def clear
		@tags.clear
		@global_tags.clear
		@decks.clear
	end
	
	def generate_tag_hash
		@tag_hash = {}
		@tags.each { |tag| @tag_hash[tag.name] = tag }
	end
	
	def search_raw_tags
		generate_tag_hash if @tag_hash == nil
		@decks.each do |deck|
			search_raw_tag_array deck.check_tags
			search_raw_tag_array deck.force_tags
			search_raw_tag_array deck.refused_tags
		end
	end
	
	def search_raw_tag_array(tag_array)
		tag_array.each_with_index do |index, tag|
			next unless tag.is_raws
			tag_array[index] = @tag_hash[tag.name]
			logger.info "not found named tag #{tag.name}" if tag_array[index] == nil
		end
		tag_array.replace tag_array.select { |tag| tag != nil }
	end
	
	def sort!
		@decks.sort { |deckA, deckB| deckB.priority <=> deckA.priority }
		@global_tags.sort { |deckA, deckB| deckB.priority <=> deckA.priority }
	end
	
	def finish
		search_raw_tags
		sort!
	end
	
	def recognize(deck)
		# 卡组检查
		deck, tags  = @decks[deck]
		# Tag 检查
		global_tags = @global_tags[deck]
		# 联合
		tags        = [] if tags == nil
		tags        += global_tags
		# 提取名字
		deck = deck.name
		tags = tags.map { |tag| tag.name }
		# 返回
		[deck, tags]
	end
	
	def [](deck)
		recognize	deck
	end
	
	@@global = DeckIdentifier.new 'global'
	
	def self.global
		return @@global
	end
end
