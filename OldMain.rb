require 'json'
require 'sqlite3'
require 'yaml'
require File.dirname(__FILE__) + '/Classification.rb'
require File.dirname(__FILE__) + '/DeckType.rb'
require File.dirname(__FILE__) + '/Tag.rb'
require File.dirname(__FILE__) + '/Compiler.rb'
require File.dirname(__FILE__) + '/API.rb'
require File.dirname(__FILE__) + '/../../Log.rb'
require File.dirname(__FILE__) + '/../../Config.rb'

module DeckIdentifier
	def self.load_file_content(file_path)
		File.open(file_path) { |f| f.read }
	end
	
	def self.load_json_file(file_path)
		str  = self.load_file_content file_path
		json = JSON.parse str
		size = self.load_json json
		logger.info "Loaded definition #{file_path}, and #{size} definitions loaded."
	end
	
	def self.load_yaml_file(file_path)
		str  = self.load_file_content file_path
		yaml = YAML.load str
		size = self.load_json yaml
		logger.info "Loaded definition #{file_path}, and #{size} definitions loaded."
	end
	
	def self.load_deckdef_file(file_path)
		self.compile_deckdef_file file_path, "json"
		size = self.load_json_file file_path + ".json"
		logger.info "Loaded definition #{file_path}, and #{size} definitions loaded."
	end
	
	def self.compile_deckdef_file(file_path, type = "json")
		compiler = DeckDefinitionCompiler.new
		compiler.compile_file file_path, type
		self.ignore_file file_path
		logger.info "Compiled file #{file_path} to #{file_path}.#{type}, and file renamed."
	end
	
	def self.ignore_file_path(file_path)
		File.join(File.dirname(file_path), "#" + File.basename(file_path))
	end
	
	def self.normalize_file_path(file_path)
		basename = File.basename file_path
		basename = basename[1..-1] if basename.start_with? '#'
		File.join File.dirname(file_path), basename
	end
	
	def self.ignore_file(file_path)
		File.rename file_path, ignore_file_path(file_path)
	end
	
	def self.normalize_file(file_path, type = "json")
		if File.exist? file_path
			logger.warn "No file named #{file_path}. Normalizing file will do nothing."
			return
		end
		normal_file_path = normalize_file_path file_path
		compiled_file    = "#{normal_file_path}.#{type}"
		if File.exist? compiled_file
			File.delete compiled_file
			logger.info "Removed compiled file #{file_path}"
		end
		File.rename file_path, normal_file_path
	end
	
	def self.load_json(json)
		if json.is_a? Hash
			self.load_json_hash json
			return 1
		elsif json.is_a? Array
			self.load_json_array json
			return json.size
		else
			# That shall never trigger
			logger.fatal "Can't recognize json #{json.class}"
			return 0
		end
	end
	
	def self.load_json_array(arr)
		arr.each { |item| self.load_json item }
	end
	
	def self.load_json_hash(json)
		type = json["type"]
		case type
			when 'deck'
				DeckType.from_json json
			when 'tag'
				Tag.from_json json
			else
				logger.warn "can't recognize type #{type}"
		end
	end
	
	def self.load_file(file_path)
		basename = File.basename file_path
		extname  = File.extname file_path
		if basename.start_with? "#"
			logger.info "ignored loading file #{file_path}"
			return nil
		end
		case extname
			when ".json"
				self.load_json_file file_path
			when ".yaml"
				self.load_yaml_file file_path
			when ".deckdef"
				self.load_deckdef_file file_path
			when ".rb"
				logger.warn "not supported now for ruby definition #{file_path}"
			else
				logger.warn "can't recognize file #{file_path}"
		end
	end
	
	def self.initialize
		config      = $config[File.dirname __FILE__]
		definitions = config["Definitions"] || []
		definitions.each { |dir| self.load_dir dir }
		DeckType.sort!
		Tag.sort!
	end
	
	def self.recognize(deck)
		# TODO: rb 检查
		# 卡组检查
		deck, tags  = DeckType[deck]
		# Tag 检查
		global_tags = Tag[deck]
		# 联合
		tags        = [] if tags == nil
		tags        += global_tags
		return [deck, tags]
		# 如果将来需要区分 Tag 的话
		[deck, tags, global_tags]
	end
	
	def self.load_dir(dir)
		files = Dir.glob File.join dir, '*.*'
		files.each { |file| self.load_file file }
	end
	
	def self.[](deck)
		self.recognize deck
	end
end

Ygoruby::DeckIdentifier.initialize