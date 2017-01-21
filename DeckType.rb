require File.dirname(__FILE__) + '/Classification.rb'
require File.dirname(__FILE__) + '/Tag.rb'

class DeckType < Classification
	attr_accessor :check_tags
	attr_accessor :force_tags, :refused_tags
	
	def load_json(json)
		super
		@check_tags = load_named_array(json, %w(check_tags tags)).map { |tag| Tag.from_json tag }
		@force_tags = load_named_array(json, 'refused_tags').map { |tag| Tag.from_json tag }
		@refused_tags =load_named_array(json, 'force_tags').map { |tag| Tag.from_json tag }
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
		@check_tags.select { |tag| tag[deck] }
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
end
