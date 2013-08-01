class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # @movies = Movie.order(params[:sort])
    # if params[:commit] == 'Refresh'
    #   session[:ratings] = params[:ratings]
    # elsif session[:ratings] != params[:ratings]
    #   redirect = true
    #   params[:ratings] = session[:ratings]
    # end

    # if params[:sort]
    #   session[:sort] = params[:sort]
    # elsif session[:sort]
    #   redirect = true
    #   params[:sort] = session[:sort]
    # end

    # @ratings = session[:ratings]
    # @sort = session[:sort]

    # if redirect
    #   redirect_to movies_path({:sort => @sort, :ratings => @ratings})
    # elsif columns = {'title' => 'title', 'release_date' => 'release_date'}
    #   if columns.has_key?(@sort)
    #     query = Movie.order(columns[@sort])
    #   else
    #     @sort = nil
    #     query = Movie
    #   end

    #   @movies = @ratings.nil? ? query.all : query.find_all_by_rating(@ratings.map { |r| r[0]} )
    #   @all_ratings = Movie.ratings
    # end
    sort = params[:sort] || session[:sort]
    case sort
    when 'title'
      ordering,@title_header = {:order => :title}, 'hilite'
    when 'release_date'
      ordering,@date_header = {:order => :release_date}, 'hilite'
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}

    if params[:sort] != session[:sort]
      session[:sort] = sort
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end

    if params[:ratings] != session[:ratings] and @selected_ratings != {}
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    @movies = Movie.find_all_by_rating(@selected_ratings.keys, ordering)
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

end
