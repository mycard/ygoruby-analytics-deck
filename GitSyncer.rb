module GitSyncer
	def self.pull(path = nil)
		path = get_path path
		logger.info 'Git: pulling path ' + path
		answer = `cd #{path} && git pull origin master --force`
		answer
	end
	
	def self.push(path = nil)
		path = get_path path
		logger.info 'Git: pushing path ' + path
		answer = `cd #{path} && git add . && git commit -q -m 'commit by program' && git push origin master`
		answer
	end
	
	def self.get_path(path = nil)
		index = 0 if path == nil
		index = path if path.is_a? Fixnum
		return path if path.is_a? String
		config = $config[File.dirname __FILE__]['Definitions']
		config = [config] if config.is_a? String
		config = [] unless config.is_a? Array
		path = config[index]
		return path
	end
end