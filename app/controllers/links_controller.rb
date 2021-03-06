class LinksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def new
    @link = Link.new
  end

  def create
    @link = Link.new(link_params)
    if @link.save
      redirect_to @link
    else
      render 'new'
    end
  end

  def show
    @link_id = Link.find(params[:id])
  end

  def shortened_link_redirect
    @link = Link.find_link(shortened_link: params[:shortened_link])
    # Also handles Active Record Not Found Error from Link::recover_full_url
    unless @link&.full_link.nil?
      redirect_to @link.full_link
    else
      redirect_to root_path
    end

  end

  private
    def link_params
      params.require(:link).permit(:full_link)
    end

end
