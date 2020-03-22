class LinksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  # GET /links/new
  def new
    @link = Link.new
  end

  # POST /links
  # POST /links.json
  def create
    @link = Link.new(link_params)

    if @link.save
      respond_to do |format|
        format.html { redirect_to @link }
        format.json {
          render json: { url: root_url << @link.shortened_link },  status: :created
        }
      end
    else
      respond_to do |format|
        format.html { render 'new' }
        format.json {
          render json: { errors: @link.errors.full_messages }, status: :unprocessable_entity
        }
      end
    end

  end

  # GET /links/1
  def show
    @link_id = Link.find(params[:id])
  end

  # GET /xXyYo0
  # GET /xXyYo0.json
  def shortened_link_redirect
    @link = Link.find_link(shortened_link: params[:shortened_link])
    # Also handles Active Record Not Found Error from Link::recover_full_url
    unless @link&.full_link.nil?
      respond_to do |format|
        format.html { redirect_to @link.full_link }
        format.json {
          render json: { full_link: @link.full_link }, status: :moved_permanently
        }
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json {
          render json: { message: "No such link" }, status: :not_found
        }
      end
    end

  end

  private
    def link_params
      params.require(:link).permit(:full_link)
    end

end
