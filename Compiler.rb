require File.dirname(__FILE__) + '/../../Log.rb'

class DeckDefinitionCompiler

	def initialize
		@layers = []
		@focus  = nil
		@tab    = 0
		@answer = []
	end

	def compile_file(file_path, type)
		file   = File.open(file_path)
		answer = execute_file file
		case type.downcase
			when 'json'
				require 'json'
				# answer = answer.to_json
				answer = JSON.pretty_generate answer
			when 'yaml'
				answer = answer.to_yaml
			else
				throw "Can't transform #{type}"
		end
		file_name = file_path + "." + type
		File.open(file_name, "w") { |f| f.write answer }
	end

	def execute_file(file)
		until file.eof?
			line = file.readline()
			execute_line line
		end
		@answer
	end

	def execute_str(str)
		arr = str.split "\n"
		arr.each { |line| execute_line line }
		@answer
	end

	def execute_line(line)
		# 移除注释
		line = comment line
		# 将 # 号恢复正常
		line.gsub! "\\#", "#"
		# 根据缩进决定顶层位置
		@tab = strip line
		decide_lay @tab
		# 去除缩进
		line.gsub! "\n", ""
		line.strip!
		return if line == ""
		# 根据类别决定分配
		type = (@focus == nil ? nil : @focus["type"])
		case type
			when nil
				top           = analyze_top_line line
				@layers[@tab] = top
				@answer.push top
			when "deck"
				analyze_deck_line line
			when "tag"
				analyze_tag_line line
			else
				# 懵逼
				logger.warn "Compiler can't recognize type #{type}"
		end
	end

	def strip(str)
		match = str[/^\s+/]
		match == nil ? 0 : match.length
	end

	def decide_lay(tab)
		num = tab
		if tab == 0
			@focus = nil
			return
		end
		while num > 0
			num -= 1
			if @layers[num] != nil
				# 从 num 开始所有的单位清空
				clear_layers num
				# 设置当前位
				@focus = @layers[num]
				return
			end
		end
		@focus = nil
	end

	def clear_layers(from)

	end

	def comment(str)
		str.split(/(?!\\#)#/)[0]
	end

	def analyze_deck_line(str)
		analyze_common_line str
	end

	def analyze_tag_line(str)
		analyze_common_line str
	end

	def analyze_common_line(str)
		# 检查是否有:标记
		syms = find_symbol(str)
		if syms != nil
			# 如果有，按照 sym 走
			sym     = syms[0].strip.downcase
			content = syms[1].strip
			case sym
				when "card"
					add_restrain(content)["type"] = "card"
				when "set"
					add_restrain(content)["type"] = "set"
				when "restrain"
					add_restrain(content)
				when "tag"
					add_tag content
				when "config"
					add_config_to_focus content
				when "priority"
					@focus["priority"] = content.to_i
			end
		else
			# 如果没有，复原:
			str.gsub! "\\:", ":"
			# 那是不是一个 ! 开头的约束？
			if str.start_with? "!"
				# 如果是，那生成一个约束
				restrain_str = str[1..-1].strip
				add_restrain restrain_str
			else
				# 那是不是一个缩写的 tag？
				tag_name = check_short_tag str
				if tag_name == nil
					# 那这啥玩意，我不认识
					add_undefined_to_focus str
				else
					# 生成一个 tag
					add_tag tag_name
				end
			end
		end
	end


	def analyze_top_line(str)
		down_str = str.downcase
		# 以 deck 标记的卡组
		if down_str.start_with? "deck"
			name = str[4..-1].strip
			deck = generate_deck name
			generate_priority deck
			deck
			# 以 tag 标记的标记
		elsif down_str.start_with? "tag"
			name = str[3..-1].strip
			tag  = generate_tag name
			generate_priority tag
			tag
		else
			name = check_short_tag(str)
			# 什么都不是，那只好认为是卡组了
			if name == nil
				deck = generate_deck str
				deck
				# 以()标记的标记
			else
				tag = generate_tag name
				tag
			end
		end
	end

	def add_restrain(str)
		restrain = generate_restrain str
		return nil if restrain.nil?
		add_restrain_to_focus restrain
		restrain
	end

	def add_tag(tag_name)
		tag = generate_tag tag_name
		return nil if tag.nil?
		@layers[@tab] = tag
		add_tag_to_focus tag
		tag
	end

	def add_restrain_to_focus(restrain)
		return unless @focus.is_a? Hash
		res = @focus["restrain"]
		if res == nil
			@focus["restrain"] = restrain
		elsif res.is_a? Array
			res.push restrain
		else
			@focus["restrain"] = [res, restrain]
		end
	end

	def add_tag_to_focus(tag)
		add_sth_to_focus "tags", tag
	end

	def add_config_to_focus(config)
		add_sth_to_focus "configs", config
	end

	def add_sth_to_focus(sym, obj)
		if @focus[sym] == nil
			@focus[sym] = [obj]
		elsif @focus[sym].is_a? Array
			@focus[sym].push obj
		else
			# failed
		end
	end

	def add_undefined_to_focus(str)
		add_config_to_focus str
	end

	def generate_deck(name = "")
		{ "type" => "deck", "name" => name }
	end

	def generate_tag(name = "")
		{ "type" => "tag", "name" => name }
	end

	def generate_restrain(str)
		# [["麒麟", " ", nil, "", ">", "=", " ", "9"]]
		# [["麒麟", " ", "Main", " ", ">", "=", " ", "9"]]
		reg     = /(.+?)(\s+?)(main|side|ex|all){0,1}(\s*?)(>|<|=)(=*)(\s*?)([0-9]+)/i
		matches = str.scan reg
		return nil if matches == []
		match    = matches[0]
		restrain = {}
		name     = match[0]
		if name.to_i != 0
			restrain["id"] = name.to_i
		else
			restrain["name"] = name
		end
		restrain["range"] = match[2] if match[2] != nil
		restrain["to"]    = match[4..7].join("")
		generate_name_and_set restrain
		restrain
	end

	# 检查这是卡名还是一个系列
	def generate_name_and_set(restrain)
		name = restrain["name"]
		return nil if name == nil
		reg     = /\[(.+?)\]/
		matches = name.scan reg
		if matches == nil or matches == []
			restrain["type"]     = "card"
			restrain["cardname"] = name
			translate_cardname_to_id restrain
			"card"
		else
			match               = matches[0]
			restrain["type"]    = "set"
			restrain["setname"] = match[0]
			"set"
		end
	end

	# 分离优先度标识
	def generate_priority(obj)
		return unless obj.is_a? Hash
		name = obj["name"]
		return nil if name == nil
		reg     = /\[(\d+?)\]$/
		matches = name.scan reg
		return false if matches == nil or matches == []
		match           = matches[0]
		obj["priority"] = match[0].to_i
		obj["name"]     = name[0..(name.length - match[0].length - 3)].strip
		true
	end

	def translate_cardname_to_id(restrain)
		name = restrain["cardname"]
		if name == nil
			logger.warn "try to translate a restrain not named."
			return
		end
		require "#{File.dirname __FILE__}/../../YgorubyBase/Card.rb"
		card = Card[name]
		# warn has given by Card.
		return if card == nil
		restrain["id"]       = card.id
		restrain["cardname"] = card.name
	end

	# 检查这行是否用 : 标记
	def find_symbol(str)
		parts = str.split /(?!\\:):/
		return nil if parts.length <= 1
		return [parts[0], parts[1..-1].join(":")]
	end

	# 检查这行是否一个 Tag
	def check_short_tag(str)
		tagMatches = /^\((.+?)\)$/
		match      = str.scan tagMatches
		if match == []
			nil
		else
			match[0][0]
		end
	end
end