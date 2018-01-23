class Tasks::ApiImport

  @prefecture

  def self.execute
    Rails.logger.debug("api import")
    # responses = ApiEvent.find_recently
    @prefectures = {}
    Prefecture.all.each{|item| @prefectures[item.name] = item }

    page_step = 50
    genres = Genre.where(level: 3)

    genres.each {|item|
      events = ApiEvent.new(genre:[item.name], count:true)
      count_result = ApiEvent.find_from_api(events)
      count = count_result.dig("count").to_i
      p "count:#{count.to_s}"
      next if count == 0

      limit_count = count + page_step
      0.step(limit_count, page_step) {|index|
        p "index:#{index.to_s}"
        event_conditions = ApiEvent.new(genre: [item.name], skip: index, limit: page_step)
        responses = ApiEvent.find_from_api(event_conditions)
          self.spot_convert(responses["tourspots"])
        }
      }
    end

    def self.spot_convert(responses)
      responses.each {|event|

        begin
          # スポット基本情報
          spot = self.parser_spot_base(event)
          db_spot  = Spot.find_by(ref_id:spot.ref_id, ref_sub_id:spot.ref_sub_id)
          if db_spot.present?
            # DBに存在していたらUPDATE
            db_spot.update_attributes(spot.attributes.compact)
            spot = db_spot
          end

          # 連絡先
          spot.prefecture = @prefectures[event.dig("place", "pref", "written")]

          # ジャンル
          spot_genres = self.parse_spot_genres(event)
          if spot_genres.blank?
            next
          end
          spot.spot_genres = spot_genres

          # スポット詳細
          spot.spot_detail = self.parse_spot_detail(event)
          # スポット詳細内容
          spot_descriptions = self.parse_spot_descriptions(event)
          # 画像
          spot_images = self.parse_spot_images(event)
          # 開催期間
          spot_terms = self.parse_spot_terms(event)
          # 付帯設備情報
          facilities = self.parse_spot_facilities(event)
          # 駐車場
          parkings   = self.parse_spot_parkings(event)

          spot.spot_terms        = spot_terms if spot_terms.present?
          spot.spot_descriptions = spot_descriptions if spot_descriptions.present?
          spot.spot_images       = spot_images if spot_images.present?
          spot.facilities = facilities if facilities.present?
          spot.parkings   = parkings if parkings.present?

          # 登録処理
          Spot.transaction do
            spot.save!
            p "commit OK spotid:#{spot.id}"
          end
        rescue => e
          p e
          Rails.logger.fatal(e)
          p spot.name
          next
        end
      }
  end

  # spot 基本情報
  def self.parser_spot_base(event)
    # p event
    spot = Spot.new

    # 管理情報
    spot.ref_city_code  = event.dig("mng", "lgcode")
    spot.ref_name       = event.dig("mng", "data_source")
    spot.ref_id         = event.dig("mng", "refbase")
    spot.ref_sub_id     = event.dig("mng", "refsub")
    spot.ref_updated_at = event.dig("mng", "status", "udate")

    # 基本情報
    spot.name        = event.dig("name", "name1", "written")
    spot.name_spoken = event.dig("name", "name1", "spoken")
    spot.body        = event["descs"].first["body"] if event.dig("descs").present?
    spot.longitude   = event.dig("place", "coordinates", "longitude")
    spot.latitude    = event.dig("place", "coordinates", "longitude")
    spot.zip         = event.dig("place", "postal_code")
    spot.active_term = event.dig("visit", "service", "open")

    # 住所情報
    spot.city     = event["place"]["city"]["written"]
    spot.address1 = event.dig("place", "street", "written")
    spot.address2 = event.dig("place", "building", "written")
    spot.tel      = event.dig("place", "phone")
    spot.fax      = event.dig("place", "fax")
    spot.email    = event.dig("place", "email")
    spot.url      = event.dig("url")

    if event.dig("views").present?
      event_info = event.dig("views").first
      spot.image_url           = "/kanko/view/#{spot.ref_id}/#{event_info.dig('fid')}"
      spot.image_copyright     = event_info.dig("copyright")
      spot.image_name          = event_info.dig("name", "written")
      spot.image_spoken        = event_info.dig("name", "spoken")
      spot.image_shooting_date = event_info.dig("when")
    end

    spot
  end

  # スポット詳細
  def self.parse_spot_detail(event)
    detail = SpotDetail.new
    detail.sub_name        = event.dig("name", "name2", "written")
    detail.sub_name_spoken = event.dig("name", "name2", "spoken")
    detail.guide_reserve   = event.dig("guide", "reservation")
    detail.guide_charge    = event.dig("guide", "charge")
    detail.guide_tel       = event.dig("guide", "phone")
    detail.guide_fax       = event.dig("guide", "fax")
    detail.guide_email     = event.dig("guide", "email")
    detail.guide_url       = event.dig("guide", "url")
    detail.guide_info      = event.dig("guide", "note")
    detail.wifi            = event.dig("wifi", "established")
    detail.bus_pickup      = event.dig("visit", "bus", "pickup_place")
    detail.bus_frequency   = event.dig("visit", "bus", "operation", "frequency")
    detail.bus_operation_time = event.dig("visit", "bus", "operation", "hour")
    detail.bus_advance_notice = event.dig("visit", "bus", "advanced", "notice")
    detail.written_us         = event.dig("foreign", "written", "lang1")
    detail.written_ch         = event.dig("foreign", "written", "lang3")
    detail.written_zh         = event.dig("foreign", "written", "lang2")
    detail.written_gr         = event.dig("foreign", "written", "lang7")
    detail.written_fr         = event.dig("foreign", "written", "lang6")
    detail.written_it         = event.dig("foreign", "written", "lang8")
    detail.written_es         = event.dig("foreign", "written", "lang10")
    detail
  end

  # ジャンル処理
  def self.parse_spot_genres(event)
    api_genres = event.dig("genres")
    spot_genres = []
    Array(api_genres).each_with_index{|item, index|
      if genre_l = Genre.where("name = ? and parent_id is null", item["L"]).first
        genre_l.genres.each{|genre_m|

          if genre_m.name == item["M"]
              genre_m.genres.map{|genre_s|
              if genre_s.name == item["S"]
                main_flg = index == 0 ? 1 : 0
                spot_genre = SpotGenre.new({genre_id: genre_s.id, level: index, main: main_flg})
                spot_genres << spot_genre
                break
              end
            }
          end
        }
      end
    }
    spot_genres
  end

  # 駐車場
  def self.parse_spot_parkings(event)

    api_parkings = event.dig("parkings")

    parkings = Array(api_parkings).map {|item|

      parking = Parking.new
      parking.name                = item.dig("name")
      parking.desc                = item.dig("desc")
      parking.company             = item.dig("company")
      parking.minutes_to_walk     = item.dig("minutes_to_walk")
      if free = item.dig("free_or_pay")
        parking.free = (free == "無料")? 1 : 0
      end
      parking.normal_capacity     = item.dig("capacity", "normal_size")
      parking.large_capacity      = item.dig("capacity", "large_size")
      parking.specialize_capacity = item.dig("capacity", "specialized")
      parking.zip                 = item.dig("postal_code")
      parking.prefecture = @prefectures[item.dig("pref")]
      if parking.prefecture.nil?
        next
      end
      parking.city                = item.dig("city")
      parking.address1            = item.dig("street")
      parking.address2            = item.dig("building")
      parking.email               = item.dig("email")
      parking.url                 = item.dig("url")
      parking.info                = item.dig("info")
      parking
    }
    parkings.compact
  end

  # 付帯設備情報
  def self.parse_spot_facilities(event)
    api_facilities = event.dig("facilities")
    facilities = Array(api_facilities).map {|item|
      facility = Facility.new
      facility.name     = item.dig("name")
      facility.quantity = item.dig("quantity")
      facility.note     = item.dig("note")
      facility
    }
    facilities
  end

  # 開催期間
  def self.parse_spot_terms(event)
    periods = event.dig("visit", "service", "periods")
    spot_terms = []
    spot_terms = Array(periods).map{|item|
      spot_term = SpotTerm.new
      spot_term.season = item.dig("season")
      if start_date = item.dig("st_date")
        spot_term.open_date  = Date.strptime(start_date,'%Y年%m月%d日')
      end
      if end_date = item.dig("en_date")
        spot_term.close_date  = Date.strptime(end_date,'%Y年%m月%d日')
      end
      spot_term.day_of_week = item.dig("day_of_week")
      spot_term.hour = item.dig("hours")
      spot_term.info = item.dig("note")
      spot_term
    }
    spot_terms
  end

  # スポット詳細内容
  def self.parse_spot_descriptions(event)
    api_descs = event.dig("descs")
    descriptions = Array(api_descs).map.with_index {|item, index|
      desc = SpotDescription.new
      desc.body = item.dig("body")
      desc.main = 1 if index == 0
      desc
    }
    descriptions
  end

  # スポット画像
  def self.parse_spot_images(event)
    ref_id    = event.dig("mng", "refbase")
    api_views = event.dig("views")
    images = Array(api_views).map {|item|
      image = SpotImage.new
      image.file_name     = "/kanko/view/#{ref_id}/#{item.dig('fid')}"
      image.copyright     = item.dig("copyright")
      image.name          = item.dig("name", "written")
      image.spoken        = item.dig("name", "spoken")
      image.shooting_date = item.dig("when")
      image
    }
    images
  end

end
