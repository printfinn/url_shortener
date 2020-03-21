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

	def shortened_link_redirect
		@link = Link.new
		shortened_link = params[:shortened_link]
		ss = @link.get_full_url(shortened_link: shortened_link)
		puts "ss: #{ss}"
		redirect_to ss
	end

	private
		def link_params
	    params.require(:link).permit(:full_link)
	  end

end
