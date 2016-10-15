require File.dirname(__FILE__) + '/../../Log.rb'
require File.dirname(__FILE__) + '/../../YgorubyBase/Card.rb'

class DeckIdentifierCompiler
	module Constants
		CommentCharacter   = '#'
		TabSpaceLength     = 2
		TypeSplitCharacter = ':'
		SetIdentifier      = '\[(.+?)\]'
		TagIdentifier      = '\((.+?)\)'
		RestrainIdentifier = '!'
		
		CommentReg            = Regexp.new ('(?!\\'+ CommentCharacter + ')' + CommentCharacter)
		TabSpaceString        = ' ' * TabSpaceLength
		SetIdentifierReg      = Regexp.new SetIdentifier
		TagIdentifierReg      = Regexp.new TagIdentifier
		PriorityIdentifierReg = Regexp.new '\[(\d+?)\]'
		RestrainReg           =/(.+?)(\s+?)(main|side|ex|all){0,1}(\s*?)(>|<|=)(=*)(\s*?)([0-9]+)/i
	end
	
	def initialize
		@root   = []
		@layers = [@root]
		@focus  = nil
	end
	
	def clear
		@layers.clear
		@layers.push @root
		@focus = nil
		@root.clear
	end
	
	def compile_file(file)
		clear
		compile_line file.readline until file.eof?
		@root
	end
	
	def compile_str(str)
		clear
		str.split("\n").each { |line| compile_line line }
		@root
	end
	
	def compile_line(line)
		# 移除注释
		remove_line_comment line
		# 计算缩进并确定其父
		tab = measure_line_strip line
		decide_lay tab
		# 取消缩进
		line.strip!
		# 空行忽略
		return if line.strip.length == 0
		# 输出到控制台
		logger.debug 'processing line ' + "[#{tab}] " + line
		# 将内容部分编译
		content      = compile_line_content line
		# 如果内容有实体，将之登记
		@layers[tab] = content if content != nil
	end
	
	def remove_line_comment(line)
		line.replace line.split(Constants::CommentReg)[0].gsub('\\' + Constants::CommentCharacter, Constants::CommentCharacter)
	end
	
	def measure_line_strip(line)
		line.gsub! '\t', Constants::TabSpaceString
		line.gsub! '\n', ''
		tab = 0
		line.gsub! /^\s+/ do |match|
			tab = match.length
			''
		end
		line.strip!
		# 为了确保 root 始终在最低位，将 tab 右移一位。
		tab + 1
	end
	
	def decide_lay(tab_count)
		while tab_count > 0
			tab_count -= 1
			next if @layers[tab_count] == nil
			@focus = @layers[tab_count]
			return
		end
	end
	
	def compile_line_content(line)
		type = check_line_type line
		type = guess_line_type line if type == nil
		# error if type == nil
		case type
			when 'deck'
				return process_line_identifier line, 'deck'
			when 'tag', 'check tag'
				return process_line_identifier line, 'tag'
			when 'identifier'
				return process_line_identifier line
			when 'and', '&', '&&'
				return process_line_restrains line, 'and'
			when 'or', '|', '||'
				return process_line_restrains line, 'or'
			when 'restrains'
				return process_line_restrains line
			when 'card'
				process_line_restrain line, 'card'
			when 'set', 'series'
				process_line_restrain line, 'set'
			when 'restrain', Constants::RestrainIdentifier
				process_line_restrain line
			when 'priority'
				process_line_priority line
			when 'config'
				process_line_config line
			when 'refuse', 'refuse tag'
				# not support now
			when 'force', 'force tag'
				# not support now
		end
		nil
	end
	
	# def check_line_type(line)
	#	  parts = line.split Constants::TypeSplitCharacter
	#	  return nil if parts.count <= 1
	#	  line.replace parts[1..-1].join Constants::TypeSplitCharacter
	# 	parts[0].downcase
	# end
	
	def check_line_type(line)
		index = line.index Constants::TypeSplitCharacter
		return nil if index == nil
		type = line[0..(index - 1)]
		line.replace line[(index + 1)..-1]
		type.downcase
	end
	
	def guess_line_type(line)
		check_line = line
		# 是不是一条以 ！开头的约束？
		if check_line.start_with? Constants::RestrainIdentifier
			line.replace line[1..-1].strip
			return 'restrain'
			# 我不信，我觉得你就是个约束
		elsif check_line[Constants::RestrainReg] != nil
			line.replace line[Constants::RestrainReg]
			return 'restrain'
		end
		# 是不是一个 Tag？
		if check_line[Constants::TagIdentifierReg] != nil
			return 'tag'
		end
		# 你是不是智障忘记写冒号了？
		check_line.downcase!
		start_flags = ['deck', 'tag', 'check tag', 'identifier', 'and', '&', '&&', 'or', '|', '||', 'restrains', 'card', 'set', 'series', 'series', 'priority', 'config']
		start_flags.each do |start_flag|
			if check_line.start_with? start_flag
				line.replace line[(start_flag.length)..-1]
				return start_flag
			end
		end
		# 如果是一个顶格 那我觉得你是个卡组定义
		if @focus == @root
			return 'deck'
		end
		# 那我也不知道了 丢个错吧
		logger.error 'unknown line ' + line
	end
	
	def add_content_to_focus(key, obj, array_form = false)
		if @focus.is_a? Array
			@focus.push obj
		elsif @focus.is_a? Hash and key != nil
			if array_form
				target = @focus[key]
				if target == nil
					@focus[key] = [obj]
				elsif target.is_a? Array
					target.push obj
				else
					# error
				end
			else
				@focus[key] = obj
			end
		else
			# error
		end
		obj
	end
	
	def process_line_identifier(content, force_type = nil)
		priority   = separate_identifier_priority content
		force_type = guess_identifier_type content if force_type == nil
		deck_name  = content.strip
		add_content_to_focus((force_type + 's').to_sym, {
				type:     force_type,
				priority: priority,
				name:     deck_name
		}, true)
	end
	
	def guess_identifier_type(identifier_name)
		scans = name.scan Constants::TagIdentifierReg
		return 'deck' if scans.count == 0
		identifier_name.replace scans[0]
		'tag'
	end
	
	def separate_identifier_priority(identifier_name)
		priority = 0
		identifier_name.gsub! Constants::PriorityIdentifierReg do |match|
			priority = $1.to_i
			''
		end
		priority
	end
	
	def process_line_restrain(content, force_type = nil)
		# 正则扫描
		matches = content.scan Constants::RestrainReg
		return {} if matches == []
		match    = matches[0]
		# 拿到名字
		name     = match[0].strip
		# 判断是卡片还是系列
		type     = guess_restrain_type name
		type     = force_type if force_type != nil
		# 构造约束
		restrain = { type: type }
		# 判断是卡片名字还是 id
		if name.to_i > 0
			restrain[:id] = name.to_i
		else
			restrain[:name] = name
			# 如果是按名称标记的卡片，那么先换算 ID。
			# restrain[:id]   = search_id_for_card_name name if type == 'card'
		end
		# 范围
		restrain[:range] = match[2] if match[2] != nil
		# 约束本体
		restrain[:to]    = match[4..7].join ''
		# 加入上级
		add_content_to_focus :restrain, restrain, true
	end
	
	def guess_restrain_type(name)
		scans = name.scan Constants::SetIdentifierReg
		return 'card' if scans.count == 0
		name.replace scans[0][0]
		return 'set'
	end
	
	def process_line_restrains(content, force_relation = nil)
		force_relation = guess_restrains_relation content if force_relation == nil
		add_content_to_focus(:restrain, {
				type:      'group',
				operator:  force_relation,
				restrains: []
		}, true)[:restrains] # 偷天换日
	end
	
	def guess_restrains_relation(content)
		content.downcase
	end
	
	def process_line_config(content)
		add_content_to_focus :config, content.strip, true
	end
	
	def process_line_priority(content)
		add_content_to_focus :priority, content.strip.to_i, true
	end
	
	def search_id_for_card_name(card_name)
		card = Card[card_name]
		card == nil ? -1 : card.id
	end
end