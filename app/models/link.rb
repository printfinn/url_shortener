class Link < ApplicationRecord
	validates :full_link, presence: true
	after_create :update_link_with_shortened_url


	private
		# Total: 26 + 26 + 10 = 62 chars
		CHAR_TO_NUMBER_DICT = [*('a'..'z'), *('A'..'Z'), *('0'..'9')]
												.each_with_index
												.to_h
		NUMBER_TO_CHAR_DICT = CHAR_TO_NUMBER_DICT.invert	
		
		def update_link_with_shortened_url
			self.shortened_link = generate_shortened_url
			save
		end

		def generate_shortened_url
			generated = ""
			n = self.id
			while n != 0
				m = n % 62
				generated << NUMBER_TO_CHAR_DICT[m]
				n = n / 62
			end
			generated << n
			return generated
		end

		def recover_full_url(shortened_url:)
			
		end


end
