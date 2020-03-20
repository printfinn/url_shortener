class LinksController < ApplicationController
	def new
		@new_link = Link.new
	end

	def create
		@new_link = Link.new(link_params)

		if @new_link.save
			redirect_to @new_link
		else
			render 'new'
		end
	end

	def show
		@link_id = Link.find(params[:id])
	end


	private
		def link_params
	    params.require(:link).permit(:full_link)
	  end

end
