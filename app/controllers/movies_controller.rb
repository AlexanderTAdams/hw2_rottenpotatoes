class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    session.clear
	@all_ratings = Movie.a_ratings 
    if params["sort"] == "title" then
	session["sort"] = params["sort"]
	end
    if params["sort"] == "release_date" then
	session["sort"] = params["sort"]
	end
    if params["commit"] == "Refresh"
	session["ratings"] = params["ratings"]
	#session["sort"] = params["sort"] 
	end
	
	@buttons = session["ratings"]
	@sort = session["sort"]
	if !@sort.nil? || !@buttons.nil?
		flash.keep
		redirect_to movies_path("sort" => @sort, "ratings" => @buttons) unless 
		!params["ratings"].nil?  || !params["sort"].nil? 
		#&& params["sort"].length>=1 && params["ratings"].length>=1
	end	
    @movies = Movie.order(@sort)
    @movies = @movies.find_all_by_rating(@buttons.keys) unless @buttons.nil?
    @buttons.nil? && @movies={}
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path 
  end

  def search_tmdb
    #hardwired to simulate failure
    flash[:warning] = "'#{params[:search_terms]}' was not found in TMDb."
    redirect_to movies_path
  end

end
