require "bundler"
Bundler.require

ActiveRecord::Base.configurations = YAML.load_file("database.yml")
ActiveRecord::Base.establish_connection(:development)

class Word < ActiveRecord::Base
end

class App < Sinatra::Base
  configure do
    set :assets_precompile, %w(application.js application.css)
    set :assets_css_compressor, :sass
    set :assets_js_compressor, :uglifier
    register Sinatra::AssetPipeline

    if defined?(RailsAssets)
      RailsAssets.load_paths.each do |path|
        settings.sprockets.append_path(path)
      end
    end
  end

  get "/" do
    p request.path
    p request.xhr?
    @word = Word.offset(rand(Word.count)).first
    haml :index, layout: !request.xhr?
  end

  get "/word.json" do
    p request.path
    p request.xhr?
    word = Word.offset(rand(Word.count)).first
    response =  {
      word: word.word,
      mean: word.mean,
      level: word.level,
    }
    json response
  end
end
