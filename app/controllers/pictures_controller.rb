class PicturesController < ApplicationController

  before_action :verify_picture_type, except: [:destroy]
  before_action :find_user
  before_action :find_picture, only: [:update, :destroy]

  respond_to :json
  
  def index
    @pictures = @user.find_pictures_by type: params[:type]
    respond_with @pictures, status: 200
  end

  def create
    @picture      = Picture.new picture_params
    @picture.user = @user

    if @picture.save
      @s3_uploader_credentials = S3UploaderCredentials.new picture: @picture
      render json: @s3_uploader_credentials.generate, status: 201
    else
      render json: { errors: @picture.errors.full_messages.first }, status: 500
    end
  end

  def mosaic
    @picture = Picture.new name: "#{DateTime.now}-mosaic.png", type: 'mosaic', user: @user
    
    if @picture.save
      CreateMosaic.perform_later params[:picture].merge({ id: @picture.id })
      render json: @picture, status: 201
    else
      render json: { errors: @picture.errors.full_messages.first }, status: 500
    end
  end

  def update
    if @picture.update picture_params
      head status: 204
    else
      render json: { errors: @picture.errors.full_messages.first }, status: 500
    end
  end

  def destroy
    if @picture.destroy
      head status: 204
    else
      render json: { errors: @picture.errors.full_messages.first }, status: 500
    end
  end

  private

    def picture_params
      params.require(:picture).permit(:name, :type, :user_id, :composition_picture_ids, :base_picture_id)
    end

    def find_picture
      @picture = Picture.find params[:id]
    rescue ActiveRecord::RecordNotFound
      render json: { errors: "Unable to find Picture with ID: #{params[:id]}" }, status: 404
    end

    def find_user
      @user = User.find params[:user_id]
    rescue ActiveRecord::RecordNotFound
      render json: { errors: "Unable to find User with ID: #{params[:user_id]}" }, status: 404
    end

    def verify_picture_type
      permitted_types = Set.new ['composition', 'base', 'mosaic', nil]

      unless permitted_types.include? params[:type]
        render json: { errors: 'Type must be one of: composition, base, mosaic' }, status: 404
      end
    end
end