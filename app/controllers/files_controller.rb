class FilesController < ApplicationController
  before_action :authenticate_user!

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
    @file = current_user.uploaded_files.find(params[:id])
    tiny_url = "https://tinyurl.com/#{SecureRandom.hex(6)}"
    render json: { tiny_url: tiny_url }
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
