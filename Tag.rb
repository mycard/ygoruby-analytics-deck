require File.dirname(__FILE__) + '/Classification.rb'
require File.dirname(__FILE__) + '/../../Log.rb'

class Tag < Classification
	class << self
		attr_accessor :tags
		attr_accessor :global_tags
	end
	@@tags           = []
	@@global_tags    = []
	self.tags        = @@tags
	self.global_tags = @@global_tags

	attr_accessor :global

	def self.from_string(str)
		for tag in @@tags
			return tag if tag.name == str
		end
		logger.warn "No tag named #{str}."
		for tag in @@tags
			return tag if tag.name.include? str
		end
		logger.warn "No tag named like #{str}."
		nil
	end

	def self.from_json(json, load_to_tags = true)
		tag = Tag.new
		tag.load_json json
		if tag.restrain == nil
			named_tag = Tag.from_string json["name"]
			tag       = named_tag if named_tag != nil
		end
		if load_to_tags
			@@tags.push tag
			@@global_tags.push tag if tag.global
		end
		tag
	end

	def load_json(json)
		super
		@global = json["global"]
		@global = false if @global.nil?
	end

	def load_obj(obj)
		load_str obj if obj.is_a? String
		load_json obj
	end

	def self.[](deck)
		@@global_tags.select { |tag| tag[deck] }
	end

	def self.sort!
		@@global_tags.sort { |t1, t2| t1.prioirty <=> t2.priority }
	end

	def to_hash
		base = super
		base[:type] = "tag"

		base
	end

	def to_json(*args)
		to_hash().to_json
	end
end