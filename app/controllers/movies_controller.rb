class MoviesController < ApplicationController

  attr_accessor :all_ratings
  attr_accessor :ratings_to_show
  attr_accessor :sorted
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @ratings_to_show = Movie.all_ratings
    @sorted = nil
    
    if params[:home] != nil and params[:home] = 1
      session[:ratings] = params[:ratings]
      session[:sortBy] = params[:sortBy]
    else
      params[:ratings] = session[:ratings]
      params[:sortBy] = session[:sortBy]
    end
    
    ratings = params[:ratings]
    sortBy = params[:sortBy]
    
    @sorted = sortBy
    
    if ratings == nil
      @ratings_to_show = @all_ratings
    else
      @ratings_to_show = ratings.keys
    end
    
    @movies = Movie.with_ratings(@ratings_to_show)
    
    @movies = Movie.get_order(@movies, sortBy)
    
    if params[:home] == nil or params[:home] != 1
      redirect_to movies_path({"home":1,"sortBy":sortBy, "ratings":ratings})
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
