class Api::V1::LinksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    @link = Link.new(link_params)
    if @link.save
      render json: { url: root_url << @link.shortened_link },  status: :created
    else
      render json: { errors: @link.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def shortened_link_redirect
    @link = Link.find_link(shortened_link: params[:shortened_link])
    # Also handles Active Record Not Found Error from Link::recover_full_url
    unless @link&.full_link.nil?
      render json: { full_link: @link.full_link }, status: :moved_permanently
    else
      render json: { message: "No such link" }, status: :not_found
    end
  end

  private
    def link_params
      params.require(:link).permit(:full_link)
    end
end
