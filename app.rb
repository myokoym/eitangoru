require "bundler"
Bundler.require

ActiveRecord::Base.configurations = YAML.load_file("database.yml")
ActiveRecord::Base.establish_connection(:development)

class Word < ActiveRecord::Base
end

class Base < Sinatra::Base
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
end

class Admin < Base
  enable :sessions

  use OmniAuth::Builder do
    provider :twitter, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']
  end

  before '/admin' do
    redirect to('/auth/twitter') unless current_user
  end

  get "/admin" do
    haml :admin
  end

  get '/auth/twitter/callback' do
    session[:uid] = env['omniauth.auth']['uid']
    redirect to('/admin')
  end

  get '/auth/failure' do
    halt 401, 'ERROR MESSAGE'
  end

  helpers do
    def current_user
      !session[:uid].nil?
    end
  end
end

class App < Base
  get "/" do
    p request.path
    p request.xhr?
    haml :index
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

  use Admin
end
