class Tasks::ApiImport

  def self.execute
      Rails.logger.debug("api import")
      responses = ApiEvent.find_popular
      p "Hello world"
      responses.each {|event|
        # p event
        spot = Spot.new
        spot.name        = event.dig("name", "name1", "written")
        spot.name_spoken = event.dig("name", "name1", "spoken")
        spot.body        = event["descs"].first unless event["descs"].nil?
        spot.longitude   = event.dig("place", "coordinates", "longitude")
        spot.latitude    = event.dig("place", "coordinates", "longitude")
        spot.zip         = event.dig("place", "postal_code")
        # t.belongs_to :prefecture, nil:false
        spot.city     = event["place"]["city"]["written"]
        spot.address1 = event.dig("place", "street", "written")
        spot.address2 = event.dig("place", "building", "written")
        spot.tel      = event.dig("place", "phone")
        spot.fax      = event.dig("place", "fax")
        spot.email    = event.dig("place", "email")
        spot.url      = event.dig("url")

        unless event.dig("views").nil? {
          event_info = event.dig("views").first
          spot.image_url           = event_info.dig("fid")
          spot.image_copyright     = event_info.dig("copyright")
          spot.image_name          = event_info.dig("name", "written")
          spot.image_spoken        = event_info.dig("name", "spoken")
          spot.image_shooting_date = event_info.dig("when")
        }


        # spot.active_term
        # spot.image_url
        # spot.image_copyright
        # spot.image_name
        # spot.image_spoken
        # spot.image_shooting_date
        # spot.ref_city_code, nil:false
        # spot.ref_name, nil:false
        # spot.ref_id, nil:false
        # spot.ref_sub_id, nil:false
        # spot.ref_updated_at, nil:false

        p spot
      }

  end


end
