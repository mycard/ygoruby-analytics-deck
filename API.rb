require "#{File.dirname __FILE__}/../Plugin.rb"
require "#{File.dirname __FILE__}/Main.rb"
require "#{File.dirname __FILE__}/../../YgorubyBase/Deck.rb"
require "#{File.dirname __FILE__}/Compiler.rb"

Ygoruby::Plugins.apis.push "get", "/deckidentifier/json" do
	json       = request.body.read
	deck       = Deck.from_hash json
	type, tags = DeckIdentifier[deck]
	content_type 'application/json'
	[type.name, tags.map { |tag| tag.name }].to_json
end

Ygoruby::Plugins.apis.push "post", "/deckidentifier/compiler" do
	deckdef = request.body.read
	deckdef.force_encoding "utf-8"
	compiler = DeckDefinitionCompiler.new
	content  = compiler.execute_str deckdef
	content  = content.map do |struct|
		type = struct["type"]
		case type
			when "deck"
				DeckType.from_json(struct)
			when "tag"
				Tag.from_json struct
			else
				nil
		end
	end
	content_type 'application/json'
	content.to_json
end