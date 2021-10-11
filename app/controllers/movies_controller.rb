class MoviesController < ApplicationController
  
  #def initialize
  #  @all_ratings = Movie.all_ratings
  #  @ratings_to_show = Movie.all_ratings
  #  @sorted = nil
  #end
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @ratings_to_show = Movie.all_ratings
    
    if params[:home] != nil and params[:home] = 1
      session[:ratings] = params[:ratings]
      #session[:sortBy] = params[:sortBy]
    else
      params[:ratings] = session[:ratings]
      params[:sortBy] = session[:sortBy]
    end
    
    ratings = params[:ratings]
    sortBy = params[:sortBy]
    
    @sorted = sortBy
    if @sorted == nil
      @sorted = session[:sortBy]
      sortBy = @sorted
      puts @sorted
      if @sorted != nil
        params[:home] = 1
      end
    else
      session[:sortBy] = @sorted
    end
    
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
