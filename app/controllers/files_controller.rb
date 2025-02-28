class FilesController < ApplicationController
  before_action :authenticate_user!
    require 'net/http'
    require 'json'
  def index
    @files = current_user.uploaded_files
  end

  def new
    @file = UploadedFile.new
  end

  def create
    @file = current_user.uploaded_files.new(file_params)
    if @file.save
      redirect_to files_path, notice: "File uploaded successfully."
    else
      render :new
    end
  end
  def share
    @file = current_user.uploaded_files.find_by(id: params[:id])
    return render json: { error: "File not found!" }, status: :not_found unless @file
    real_url = rails_blob_url(@file.file, disposition: "inline")
    tiny_url = Net::HTTP.get(URI("https://tinyurl.com/api-create.php?url=#{real_url}")).strip
    if tiny_url.include?("http")
      render json: { tiny_url: tiny_url }
    else
      render json: { error: "Failed to generate TinyURL. Please try again." }, status: :unprocessable_entity
    end
  end  

  def show
    @file = current_user.uploaded_files.find_by(id: params[:id])
    if @file
      render :show
    else
      redirect_to files_path, alert: "⚠️ File not found!"
    end
  end
  
  
  def destroy
    @file = current_user.uploaded_files.find(params[:id])
    @file.destroy
    redirect_to files_path, notice: "File deleted successfully."
  end

  private

  def file_params
    params.require(:uploaded_file).permit(:title, :description, :file)
  end
end
