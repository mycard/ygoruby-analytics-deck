require File.dirname(__FILE__) + '/Restrain.rb'

class Classification
	attr_accessor :name
	attr_accessor :priority
	attr_accessor :restrain
	DefaultClassificationName = '神秘的类别'
	DefaultPriority           = 0
	
	def load_json(json)
		load_json_name json
		load_json_priority json
		load_json_restrain json
	end
	
	def load_json_name(json)
		@name = json['name']
		@name = DefaultClassificationName if @name == nil
	end
	
	def load_json_priority(json)
		@priority = json['priority']
		@priority = DefaultPriority if @priority == nil
		@priority = @priority.to_i unless @priority.is_a? Integer
	end
	
	def load_json_restrain(json)
		@restrain = json['restrains']
		@restrain = json['restrain'] if @restrain.nil?
		@restrain = Restrain.from_json @restrain if @restrain != nil
	end
	
	def [](deck)
		if @restrain == nil
			return false
		end
		return @restrain[deck] > 0
	end
	
	def to_hash
		hash = {
				name:     @name,
				priority: @priority
		}
		hash[:restrain] = @restrain.to_hash if @restrain != nil
		hash
	end
	
	def to_json(*args)
		to_hash().to_json
	end
	
	def load_named_array(json, names)
		names = [names] unless names.is_a? Array
		arr   = nil
		names.each do |name|
			next if json[name] == nil
			arr = json[name]
			break
		end
		arr = [] unless arr.is_a? Array
		arr
	end
end