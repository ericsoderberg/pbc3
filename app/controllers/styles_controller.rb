class StylesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!

  # GET /styles
  # GET /styles.xml
  def index
    @styles = Style.order('LOWER(name) ASC');

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @styles }
    end
  end

  # GET /styles/1
  # GET /styles/1.xml
  def show
    @style = Style.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @style }
    end
  end

  # GET /styles/new
  # GET /styles/new.xml
  def new
    @style = Style.new
    @style.hero_text_color = 0x000000;
    @style.feature_color = 0x333333;

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @style }
    end
  end

  # GET /styles/1/edit
  def edit
    @style = Style.find(params[:id])
    @pages = @style.pages
  end

  # POST /styles
  # POST /styles.xml
  def create
    fix_colors
    @style = Style.new(style_params)

    respond_to do |format|
      if @style.save
        format.html { redirect_to(styles_url,
          :notice => 'Style was successfully created.') }
        format.xml  { render :xml => @style, :status => :created, :location => @style }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @style.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /styles/1
  # PUT /styles/1.xml
  def update
    fix_colors
    @style = Style.find(params[:id])
    @style.banner = nil if params[:delete_banner]
    @style.feature_strip = nil if params[:delete_feature_strip]
    @style.hero = nil if params[:delete_hero]
    @style.bio_back = nil if params[:delete_bio_back]
    @style.child_feature = nil if params[:delete_child_feature]

    respond_to do |format|
      if @style.update_attributes(style_params)
        format.html { redirect_to(styles_url,
          :notice => 'Style was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @style.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /styles/1
  # DELETE /styles/1.xml
  def destroy
    @style = Style.find(params[:id])
    @style.destroy

    respond_to do |format|
      format.html { redirect_to(styles_url) }
      format.xml  { head :ok }
    end
  end

  private

  def fix_colors
    if params[:style][:feature_color] and
        params[:style][:feature_color].is_a?(String)
      params[:style][:feature_color] =
        params[:style][:feature_color].hex
    end
    if params[:style][:hero_text_color] and
        params[:style][:hero_text_color].is_a?(String)
      params[:style][:hero_text_color] =
        params[:style][:hero_text_color].hex
    end
    if params[:style][:bio_back_color] and
        params[:style][:bio_back_color].is_a?(String)
      params[:style][:bio_back_color] =
        params[:style][:bio_back_color].hex
    end
    if params[:style][:banner_text_color] and
        params[:style][:banner_text_color].is_a?(String)
      params[:style][:banner_text_color] =
        params[:style][:banner_text_color].hex
    end
    if params[:style][:child_feature_text_color] and
        params[:style][:child_feature_text_color].is_a?(String)
      params[:style][:child_feature_text_color] =
        params[:style][:child_feature_text_color].hex
    end
  end

  def style_params
    params.require(:style).permit(:name, :hero_text_color, :feature_color,
      :banner_text_color, :banner, :feature_strip, :hero, :bio_back,
      :child_feature, :updated_by, :hero_text_background_overlay).merge(:updated_by => current_user)
  end
end
