require File.dirname(__FILE__) + '/Condition.rb'
require File.dirname(__FILE__) + '/DeckRange.rb'
require File.dirname(__FILE__) + '/../../YgorubyBase/Card.rb'
require File.dirname(__FILE__) + '/../../YgorubyBase/CardSet.rb'
require File.dirname(__FILE__) + '/../../Log.rb'

class Restrain
	attr_accessor :type
	attr_accessor :condition
	attr_accessor :range

	def self.from_json(json)
		json     = { "type" => "group", "restrains" => json } if json.is_a? Array
		type     = json['type']
		type     = type.downcase unless type.nil?
		restrain = RestrainGroup.from_json(json) if type == 'group' or json['restrains'] != nil
		restrain = RestrainCardID.from_json(json) if type == 'id'
		restrain = RestrainCardID.from_json(json) if type == 'card'
		restrain = RestrainCardSet.from_json(json) if type == 'set'
		return nil if restrain.nil?
		restrain.type = type
		restrain
	end

	def [](deck)
		false
	end

	def to_hash
		hash = {
				type:      @type
		}
		hash[:condition] = @condition.to_hash unless @condition.nil?
		hash[:range] = @range.to_hash unless @range.nil?
		hash
	end

	def to_json
		to_hash().to_json
	end
end

class RestrainGroup < Restrain
	attr_accessor :restrains
	attr_accessor :operator

	def self.from_json(json)
		restrain           = RestrainGroup.new
		restrain.operator  = json["operator"]
		restrain.operator  = "and" if restrain.operator == nil
		restrain.restrains = json["restrains"]
		restrain.restrains = [] if restrain.restrains == nil
		restrain.restrains = restrain.restrains.map { |restrain| Restrain.from_json restrain }
		restrain.restrains = restrain.restrains.select { |restrain| restrain != nil }
		restrain
	end

	def [](deck)
		results    = @restrains.map { |restrain| restrain[deck] }
		true_count = (results.select { |result| result }).count
		return @operator[true_count] if @operator.is_a? Condition
		case @operator
			when 'and', '&', '&&'
				return true_count == results.count
			when 'or', '|', '||'
				return true_count >= 1
			else
				return false
		end
	end

	def to_hash
		base            = super
		base[:operator] = @operator
		restrains_hash  = []
		@restrains.each { |restrain| restrains_hash.push restrain.to_hash }
		base[:restrains] = restrains_hash
	end

	def to_json
		to_hash().to_json
	end
end

class RestrainCardID < Restrain
	attr_accessor :id

	def self.from_json(json)
		restrain           = RestrainCardID.new
		restrain.id        = json["id"]
		restrain.id        = 0 if restrain.id.nil?
		restrain.condition = json["to"]
		restrain.condition = ">=0" if restrain.condition.nil?
		restrain.condition = Condition.from_s(restrain.condition)
		restrain.range     = json["range"]
		restrain.range     = "all" if restrain.range == nil
		restrain.range     = DeckRange.new restrain.range
		return restrain if restrain.id != nil
		name = json["cardname"]
		name = json["name"] if name == nil
		if name != nil
			id = RestrainCardID.search_id_by_name name
			if id != nil and id != 0
				restrain.id = id
			end
		end
		restrain
	end

	def self.search_id_by_name(name)
		card = Card[name]
		return nil if card.nil?
		card.id
	end

	def [](deck)
		return false if id == nil or @range == nil or @condition == nil
		cards  = @range.classified deck
		number = cards[@id]
		number = 0 if number == nil
		@condition[number]
	end

	def to_hash
		base      = super
		base[:id] = @id
		base[:name] = Card[@id].name
		base
	end

	def to_json
		to_hash().to_json
	end
end

class RestrainCardSet < Restrain
	attr_accessor :set

	def self.from_json(json)
		restrain           = RestrainCardSet.new
		restrain.set       = json["setname"]
		restrain.set       = json["name"] if restrain.set.nil?
		restrain.set       = "" if restrain.set.nil?
		restrain.set       = search_set_by_name restrain.set
		restrain.condition = json["to"]
		restrain.condition = ">=0" if restrain.condition.nil?
		restrain.condition = Condition.from_s(restrain.condition)
		restrain.range     = json["range"]
		restrain.range     = "all" if restrain.range == nil
		restrain.range     = DeckRange.new restrain.range
		restrain
	end

	def self.search_set_by_name(name)
		return CardSet[name]
	end

	def [](deck)
		return false if @set == nil or @range == nil or @condition == nil
		cards  = @range[deck]
		number = 0
		cards.each { |card| number += 1 if set.ids.include? card }
		@condition[number]
	end

	def to_hash
		base       = super
		base[:set] = @set.to_hash unless @set.nil?
		base[:name] = @set.name unless @set.nil?
		base
	end

	def to_json
		to_hash().to_json
	end
end