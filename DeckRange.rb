class DeckRange
	# 取值：
	# main 主牌
	# side 备牌
	# ex 额外
    # ori 主牌与额外
	# all 所有
	attr_accessor :range

	def initialize(range)
		@range = range
	end

	def classified(deck)
		case range
			when 'main'
				return deck.main_classified
			when 'side'
				return deck.side_classified
			when 'ex'
				return deck.ex_classified
			when 'ori'
				return deck.ori_classified
			when 'all'
				return deck.cards_classified
			else
				return deck.cards_classified
		end
	end

	def [](deck)
		case range
			when 'main'
				return deck.main
			when 'side'
				return deck.side
			when 'ex'
				return deck.ex
			when 'ori'
				return deck.main + deck.ex
			when 'all'
				return deck.main + deck.side + deck.ex
			else
				return deck.main + deck.side + deck.ex
		end
	end

	def to_hash
		@range
	end
end
