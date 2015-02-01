class AuthorsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :administrator!, :except => [:index, :show]
  
  # GET /authors
  # GET /authors.xml
  def index
    @authors = Author.all.to_a
    @single_authors = []
    @multiple_authors = []
    ##@authors.sort!{|a1, a2| a2.first_year <=> a1.first_year}
    @authors.each do |author|
      if author.messages.count > 1
        @multiple_authors << author
      else
        @single_authors << author
      end
    end
    first_decade = Message.exists? ? (Message.order('date ASC').first.date.year / 10) : Time.now.year
    last_decade = Message.exists? ? (Message.order('date ASC').last.date.year / 10) : Time.now.year
    @decades = (first_decade..last_decade).map{|d| d * 10}
    @num_years = (@decades.last + 10) - @decades.first
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @authors }
    end
  end

  # GET /authors/1
  # GET /authors/1.xml
  def show
    @author = Author.find_by(url: params[:id])
    @messages = @author.messages
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @author }
    end
  end

  # GET /authors/new
  # GET /authors/new.xml
  def new
    @author = Author.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @author }
    end
  end

  # GET /authors/1/edit
  def edit
    @author = Author.find_by(url: params[:id])
  end

  # POST /authors
  # POST /authors.xml
  def create
    @author = Author.new(author_params)

    respond_to do |format|
      if @author.save
        format.html { redirect_to(authors_url,
          :notice => 'Author was successfully created.') }
        format.xml  { render :xml => @author, :status => :created, :location => @author }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @author.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /authors/1
  # PUT /authors/1.xml
  def update
    @author = Author.find_by(url: params[:id])

    respond_to do |format|
      if @author.update_attributes(author_params)
        format.html { redirect_to(@author, :notice => 'Author was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @author.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /authors/1
  # DELETE /authors/1.xml
  def destroy
    @author = Author.find_by(url: params[:id])
    @author.destroy

    respond_to do |format|
      format.html { redirect_to(authors_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def author_params
    params.require(:author).permit(:name, :url, :description)
  end
  
end
