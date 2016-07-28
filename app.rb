require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/sequel'
require 'active_support'
require 'active_support/core_ext'


class App < Sinatra::Application
  configure do
    set :erb, escape_html: true

    set :sessions,
        httponly: true,
        secure: production?,
        expire_after: 5.years,
        secret: ENV['SESSION_SECRET']
  end

  configure :production, :development do
    DB = Sequel.connect('sqlite://db/iroh.db')
    DB.loggers << Logger.new(STDOUT)
  end


  configure :development do
    register Sinatra::Reloader
  end

end

require_relative 'models/init'
require_relative 'helpers/init'
require_relative 'routes/init'