class MessagesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :map_old_file, :suggestions]
  before_filter :administrator!, :except => [:index, :show, :map_old_file, :suggestions]

  layout "administration", only: [:new, :edit, :delete]

  def index
    @filter = {}
    @filter[:search] = params[:search] || ''

    # parse search
    tokens = Message.parse_query(@filter[:search])

    @messages = Message

    # build query based on token score

    strong_tokens = tokens.select{|t| t[:score] > 0 and t[:clause]}
    weak_tokens = tokens.select{|t| t[:score] == 0 and t[:clause]}

    args = {}
    weak_clause = strong_clause = nil

    if not weak_tokens.empty?
      weak_clause = "(" + weak_tokens.map{|t| t[:clause]}.join(' OR ') + ")"
      weak_tokens.each{|t| args.merge!(t[:args])}
    end

    if not strong_tokens.empty?
      strong_clause = strong_tokens.map{|t| t[:clause]}.join(' AND ')
      strong_tokens.each{|t| args.merge!(t[:args])}
    end

    clause = if strong_clause
      if weak_clause
        "#{strong_clause} AND #{weak_clause}"
      else
        strong_clause
      end
    elsif weak_clause
      weak_clause
    end

    if @filter[:search].length > 0 and ! clause
      @messages = @messages.none
    end

    @messages = @messages.includes(:author, :verse_ranges)
    @messages = @messages.where(clause, args).references(:authors) if clause
    @messages = @messages.order('date DESC')

    # get total count before we limit
    @count = @messages.count

    if params[:offset]
      @messages = @messages.offset(params[:offset])
    end
    @messages = @messages.limit(20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :partial => "index" }
    end
  end

  def suggestions
    query = params[:q] || ''
    tokens = Message.parse_query(query)
    @suggestions = []

    references = tokens.select{|t| 'reference' == t[:type]}.map{|t| t[:matches]}.flatten.slice(0,5)
    @suggestions << {label: 'Bible References', suggestions: references} unless references.empty?
    messages = tokens.select{|t| 'message' == t[:type]}.map{|t| t[:matches]}
    if not messages.empty?
      titles = messages.first.limit(5).pluck('title')
      @suggestions << {label: 'Messages', suggestions: titles}
    end
    authors = tokens.select{|t| 'author' == t[:type]}.map{|t| t[:matches]}
    if not authors.empty?
      names = authors.first.limit(5).pluck('name')
      @suggestions << {label: 'Authors', suggestions: names}
    end
    dates = tokens.select{|t| 'date' == t[:type]}.map{|t| t[:matches]}.flatten.slice(0, 5)
    @suggestions << {label: 'Dates', suggestions: dates} unless dates.empty?

    respond_to do |format|
      format.json { render :partial => "suggestions" }
    end
  end

  def show
    @message = Message.includes(:author, :message_files).find_by(url: params[:id])
    @message = Message.includes(:author, :message_files).find(params[:id]) unless @message
    @files = @message.ordered_files
    @previous_message = @message.previous
    @next_message = @message.next

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :partial => "show" }
    end
  end

  def map_old_file
    @message_file = MessageFile.where(:file_file_name => params[:file_name]).first
    if @message_file
      redirect_to @message_file.message
      return
    else
      redirect_to messages_path
      return
    end
  end

  def new
    if params[:series_id]
      @message_set = MessageSet.find_by(url: params[:series_id])
      @message = @message_set.messages.new
      @message.author = @message_set.author
    else
      @message = Message.new
    end
    @message.date = Date.today
    @authors = Author.order('name ASC')
    @message_sets = MessageSet.order('title ASC')

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @message = Message.find_by(url: params[:id])
    @message_file = if params[:message_file_id]
      @message.message_files.find(params[:message_file_id])
    else
      @message_file = @message.message_files.new
    end
    @possible_events = @message.possible_events
    @authors = Author.order('name ASC')
    @message_sets = MessageSet.order('title ASC')
  end

  def create
    parse_date
    @message = Message.new(message_params)
    if params[:message_file]
      @message_file = @message.message_files.build(params[:message_file])
      @message_file.message = @message
    end

    respond_to do |format|
      if @message.save
        format.html { redirect_to((@message.message_set ?
          series_path(@message.message_set) : @message),
          :notice => 'Message was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    parse_date
    @message = Message.find_by(url: params[:id])
    @message.image = nil if params[:delete_image]
    @message.events = Event.find(params[:events]) if params[:events]

    respond_to do |format|
      if @message.update_attributes(message_params)
        format.html { redirect_to(@message, :notice => 'Message was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @message = Message.find_by(url: params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to(messages_url) }
    end
  end

  private

  def parse_date
    if params[:message][:date] and params[:message][:date].is_a?(String)
      params[:message][:date] =
        Date.parse_from_form(params[:message][:date])
    end
  end

  def message_params
    params.require(:message).permit(:title, :url, :verses, :date, :author_id,
      :dpid, :description, :message_set_id, :message_set_index, :event_id,
      :library_id, :image, :updated_by).merge(:updated_by => current_user)
  end

end
