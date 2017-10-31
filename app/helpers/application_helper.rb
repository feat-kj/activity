module ApplicationHelper
  # イベント用画像URLを返却
  def event_image_url(event_id, image_name)
    return AppConfig.api.url + "kanko/view/#{event_id}/#{image_name}"
  end
end
