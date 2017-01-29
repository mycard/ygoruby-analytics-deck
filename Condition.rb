class Condition
	attr_accessor :operator
	attr_accessor :number

	def initialize(operator, number)
		@operator = operator.strip
		@number   = number
	end

	def [](value)
		case @operator
			when '>'
				return value > @number
			when '<'
				return value < @number
			when '<='
				return value <= @number
			when '>='
				return value >= @number
			when '=', '=='
				return value == @number
			else
				return false
		end
	end

	def to_s
		"Condition [#{@operator} #{@number}]"
	end

	Reg = /([><=]*=*)(\s*)(\d+)/

	def self.from_s(str)
		results = str.scan(Reg).select { |result| result[0] + result[1] != '' }
		return nil if results == []
		result = results[0]
		return Condition.new(result[0] + result[1], result[2].to_i)
	end

	def to_hash
		{
				operator: @operator,
				number:   @number
		}
	end

	def to_json(*args)
		to_hash().to_json
	end
end