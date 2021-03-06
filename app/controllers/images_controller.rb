class ImagesController < ApplicationController
  before_action :set_image, except: %i[new create index]

  def data
    send_data @image.data, filename: @image.description, disposition: :inline
  end

  def data_analyzed
    send_data @image.analyzed_data, filename: @image.description, disposition: :inline
  end

  # GET /images
  # GET /images.json
  def index
    @images = Image.all
  end

  # GET /images/1
  # GET /images/1.json
  def show
    @samples = ImageReaderService.new(@image).analyze.generate_samples 4
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # POST /images
  # POST /images.json
  def create
    data = image_params[:data]

    if data
      @image = Image.new.tap do |t|
        t.data = data.read
        t.description = data.original_filename
      end
    end

    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: 'Image was successfully created.' }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_image
    @image = Image.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def image_params
    params.require(:image).permit(:data, :analyzed_data, :description)
  end
end
