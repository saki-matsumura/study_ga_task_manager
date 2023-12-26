module UsersHelper
  def default_img(image)
    image.presence || 'icon.png'
  end
end
