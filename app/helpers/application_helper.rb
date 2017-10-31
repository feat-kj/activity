module ApplicationHelper

  # 画像イメージパスを返却
  def event_image_url(event_id, image_name)
    reutrn AppConfig.api.url + "kanko/view/#{event_id}/#{image_name}"
  end
end
