class Admin::MediaController < ApplicationController
  def index
    @media = Medium.all.order(created_at: :desc)
  end

  def new
    @medium = Medium.new
  end

  def create
    @medium = Medium.new(medium_params)
    @medium.user = Current.user
    if @medium.file.attached?
      @medium.name ||= @medium.file.filename.to_s
      @medium.file_type = @medium.file.content_type
      @medium.size = @medium.file.byte_size
    end

    if @medium.save
      redirect_to admin_media_path, notice: "File uploaded successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @medium = Medium.find(params[:id])
    @medium.destroy
    redirect_to admin_media_path, notice: "File removed."
  end

  private

  def medium_params
    params.require(:medium).permit(:name, :file)
  end
end
