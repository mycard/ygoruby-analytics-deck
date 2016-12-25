require 'json'
require 'yaml'
require 'sqlite3'
require "#{File.dirname __FILE__}/../../YgorubyBase/CardSet.rb"

def cardSetTest
	CardSet.load_conf
	sql         = SQLite3::Database.new($config["DeckIdentifier"]["cdb"])
	CardSet.sql = sql
end

def decktypeTest
	str  = File.open("./Definition/Pendulum-example.json") { |f| f.read }
	json = JSON.parse str
	require './DeckType.rb'
	deck = DeckType.new
	deck.load_json(json[0])
	deck
end

def yamlloadTest
	str  = File.open("./Definition/Lightswarn-example.yaml")
	yaml = YAML.load str
	require './DeckType.rb'
	deck = DeckType.new
	deck.load_json(yaml)
end

def compilerTest
	file = "#{File.dirname __FILE__}/Definition/PedulumSets-example.deckdef"
	require "#{File.dirname __FILE__}/Compiler.rb"
	DeckDefinitionCompiler.new.compile_file file, 'json'
end

def mainTest
	require "./Main.rb"
end

def mainRevertTest
	require "./Main.rb"
	DeckIdentifier.normalize_file "./Definition/#PedulumSets-example.deckdef"
end

def cardTest
	sql = SQLite3::Database.new($config["DeckIdentifier"]["cdb"])
	require "./Card.rb"
	Card.sql = sql
	p Card["威风妖怪·麒麟"]
end

def identifyTest
	require "./main.rb"
	require './YgocoreRubyHelper/Main.rb'
	deck   = Ygocore::Deck.load_ydk "./TestDeck/手抄堕天使A.ydk"
	answer = DeckIdentifier[deck]
	answer
end

def outputTest
	require "#{File.dirname __FILE__}/Main.rb"
	json = []
	DeckType.decks.each {|type| json.push type.to_hash}
	File.open("#{File.dirname __FILE__}/Server/example.json", "w") {|f| f.write JSON.pretty_generate json}
end

def startTest
	require File.dirname(__FILE__) + '/DeckIdentifier.rb'
	DeckIdentifier.global.register_config
end

startTest