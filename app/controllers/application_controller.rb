class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json' #adds application/json content type header for all responses (in html format if default not specified)

  get '/' do
    { message: "Hello world" }.to_json
  end

  get '/games' do
    games = Game.all.order(:title) #get all games from the database and order by title
    # or return only top 10 games
    #games = Game.all.order(:title).limit(10)
    games.to_json
  end

  get '/games/:id' do #add dynamic route to access individual game info by id
    game = Game.find(params[:id])
    # or game.to_json(include: :reviews) for just reviews
    # or game.to_json(include: { reviews: { include: :user } }) for all columns of reviews and all columns of user
    #only specifies which columns/keys to send data for
    game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      }}
    })
  end
end
