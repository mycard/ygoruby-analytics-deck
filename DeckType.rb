require File.dirname(__FILE__) + '/Classification.rb'
require File.dirname(__FILE__) + '/Tag.rb'

class DeckType < Classification
	class << self
		attr_accessor :decks
	end
	@@decks    = []
	self.decks = @@decks

	attr_accessor :tags

	def load_json(json)
		super
		@tags = json["tags"]
		@tags = [] if @tags == nil
		@tags = [] unless @tags.is_a? Array
		@tags = @tags.select { |tag| Tag.from_json tag, false }
		@@decks.push self
	end

	def self.from_json(json)
		deck = DeckType.new
		deck.load_json json
		deck
	end

	def [](deck)
		match = super
		return false unless match
		return [] if @tags == nil
		@tags.select { |tag| tag[deck] }
	end

	def self.[](deck)
		for type in @@decks
			answer = type[deck]
			return [type, answer] if answer
		end
		nil
	end

	def self.sort!
		@@decks.sort! { |d1, d2| d1.priority <=> d2.priority }
	end

	def to_hash
		base      = super
		tags_hash = []
		tags.each { |tag| tags_hash.push tag.to_hash }
		base[:tags] = tags_hash
		base[:type] = "deck"
		base
	end

	def to_json(*args)
		to_hash().to_json
	end
end
