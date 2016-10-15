require File.dirname(__FILE__) + '/Restrain.rb'

class Classification
	attr_accessor :name
	attr_accessor :priority
	attr_accessor :restrain
	Default_classification_name = "神秘的类别"
	Default_Prioroty            = 0

	def load_json(json)
		load_json_name json
		load_json_priority json
		load_json_restrain json
	end

	def load_json_name(json)
		@name = json["name"]
		@name = Default_classification_name if @name == nil
	end

	def load_json_priority(json)
		@priority = json["priority"]
		@priority = Default_Prioroty if @priority == nil
		@priority = @priority.to_i unless @priority.is_a? Integer
	end

	def load_json_restrain(json)
		@restrain = json["restrains"]
		@restrain = json["restrain"] if @restrain.nil?
		@restrain = Restrain.from_json @restrain if @restrain != nil
	end

	def [](deck)
		if @restrain == nil
			return false
		end
		return @restrain[deck]
	end

	def to_hash
		{
				name:     @name,
				priority: @priority,
				restrain: @restrain.to_hash
		}
	end

	def to_json(*args)
		to_hash().to_json
	end
end