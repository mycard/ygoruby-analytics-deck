require File.dirname(__FILE__) + '/Classification.rb'
require File.dirname(__FILE__) + '/../../Log.rb'

class Tag < Classification
	attr_accessor :configs
	
	def self.from_json(json)
		tag = Tag.new
		tag.load_json json
		tag
	end

	def load_json(json)
		super
		load_config json
	end
	
	def load_config(json)
		@configs = json['config']
		@configs = json['configs'] if @configs == nil
		@configs = [] if @configs == nil
		@configs = [] unless @configs.is_a? Array
	end
	
	def is_raw?
		@restrain.nil? or @restrain == []
	end
	
	def is_global?
		return @configs.include? 'global'
	end
	
	def can_upgrade?
		return @configs.include? 'upgrade'
	end

	def to_hash
		base = super
		base[:type] = 'tag'
		base
	end

	def to_json(*args)
		to_hash().to_json
	end
	
	def to_s
		"tag #{name}"
	end
end