module GitSyncer
	def self.pull(path = nil)
		path = 0 if path == nil
		path = get_path path if path.is_a? Fixnum
		if path == nil
			console.warn 'try to pull a nil path'
			return
		end
		logger.info 'Git: pulling path ' + path
		save_path
		`cd #{path} & git pull origin --force`
		load_path
	end
	
	def self.push(path = nil)
		path = 0 if path == nil
		path = get_path path if path.is_a? Fixnum
		if path == nil
			console.warn 'try to pull a nil path'
			return
		end
		logger.info 'Git: pushing path ' + path
		save_path
		`cd #{path} & git add . & git commit -ad 'commit by program' & git push`
		load_path
	end
	
	def self.save_path
		@@origin_path = File.expand_path('.')
	end
	
	def self.load_path
		`cd #{@@origin_path}`
	end
	
	def self.get_path(index = 0)
		config = $config[File.dirname __FILE__]['Definitions']
		config = [config] if config.is_a? String
		config = [] unless config.is_a? Array
		return config[index]
	end
end