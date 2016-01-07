require "bundler"
Bundler.require

ActiveRecord::Base.configurations = YAML.load_file("database.yml")
ActiveRecord::Base.establish_connection(:development)

class Word < ActiveRecord::Base
end

class App < Sinatra::Base
  get "/" do
    @word = Word.offset(rand(Word.count)).first
    haml :index
  end
end
