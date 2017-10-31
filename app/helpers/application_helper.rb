module ApplicationHelper
  # イベント用画像URLを返却
  def event_image_url(event_id, image_name)
    if event_id.blank? || image_name.blank?
      return 'http://placehold.it/700x450'
    end
    return AppConfig.api.url + "kanko/view/#{event_id}/#{image_name}"
  end
end
