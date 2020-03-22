class Link < ApplicationRecord
  validates :full_link, presence: true
  after_create :update_link_with_shortened_link
  after_validation :smart_add_url_protocol


  def self.find_link(shortened_link:)
    if shortened_link_is_valid?(shortened_link)
      return recover_link(shortened_link)
    else
      return nil
    end
  end

  private
    # Total: 26 + 26 + 10 = DICT_SIZE chars
    CHAR_TO_NUMBER_DICT = [*('a'..'z'), *('A'..'Z'), *('0'..'9')]
                        .each_with_index
                        .to_h
    NUMBER_TO_CHAR_DICT = CHAR_TO_NUMBER_DICT.invert
    DICT_SIZE = CHAR_TO_NUMBER_DICT.size
    
    # update database
    def update_link_with_shortened_link
      self.shortened_link = generate_shortened_link
      save
    end

    # in case user didn't input http:// or https://
    def smart_add_url_protocol
      unless self.full_link and (self.full_link[/\Ahttp:\/\//] || self.full_link[/\Ahttps:\/\//])
        self.full_link = "http://#{self.full_link}"
      end
    end

    # https://stackoverflow.com/questions/742013/how-do-i-create-a-url-shortener
    def generate_shortened_link
      generated = ""
      n = self.id
      while n != 0
        m = n % DICT_SIZE
        generated << NUMBER_TO_CHAR_DICT[m]
        n = n / DICT_SIZE
      end
      generated.reverse
    end

    def self.find_shortened_link_primary_id(shortened_link)
      primary_id = 0
      shortened_link.reverse!
      shortened_link.each_char.with_index do |char, i|
        primary_id += CHAR_TO_NUMBER_DICT[char] * (DICT_SIZE ** i)
      end
      primary_id
    end

    def self.recover_link(shortened_link)
      link_id = find_shortened_link_primary_id(shortened_link)
      Link.find_by(id: link_id)
    end

    # Shortened link should not exceed 6 characters, nor includes illegal characters
    # Otherwise calculating primary id would result into invalid number
    def self.shortened_link_is_valid?(shortened_link)
      !!(shortened_link =~ /^[A-Za-z0-9]{1,6}$/)
    end
end
