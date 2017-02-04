require File.dirname(__FILE__) + '/Classification.rb'
require File.dirname(__FILE__) + '/Tag.rb'

class DeckType < Classification
	attr_accessor :check_tags
	attr_accessor :force_tags, :refused_tags
	
	def initialize
		super
		@check_tags = []
		@force_tags = []
		@refused_tags = []
	end
	
	def load_json(json)
		super
		@check_tags = load_named_array(json, %w(check_tags tags)).map { |tag| Tag.from_json tag }
		@force_tags = load_named_array(json, 'force tags').map { |tag| Tag.from_json tag }
		@refused_tags =load_named_array(json, 'refuse tags').map { |tag| Tag.from_json tag }
		
	end

	def self.from_json(json)
		deck = DeckType.new
		deck.load_json json
		deck
	end

	def [](deck)
		match = super
		return false unless match
		return [] if @check_tags == nil
		@force_tags + @check_tags.select { |tag| tag[deck] }
	end
	
	def to_hash
		base              = super
		base[:check_tags] = @check_tags.map { |tag| tag.to_hash }
		base[:force_tags] = @force_tags.map { |tag| tag.to_hash }
		base[:refused_tags] = @refused_tags.map { |tag| tag.to_hash }
		base[:type] = 'deck'
		base
	end

	def to_json(*args)
		to_hash().to_json
	end
	 
	def to_s
		"deck type [#{name}]"
	end
	
	def get_name(tags)
		basic_name = @name
		remain_tags = tags.select do |tag|
			basic_name = tag.name + basic_name if tag.is_prefix?
			basic_name += tag.name if tag.is_appendix?
			not (tag.is_prefix? or tag.is_appendix?)
		end
		tags.replace remain_tags
		basic_name
	end
end
