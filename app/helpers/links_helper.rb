module LinksHelper
  def show_url_for(url)
    dest = root_url << url
    dest
  end
end
