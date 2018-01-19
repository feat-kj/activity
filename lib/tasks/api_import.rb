class Tasks::ApiImport

  def self.execute
      Rails.logger.debug("api import")
      responses = ApiEvent.find_recently
      prefectures = {}
      Prefecture.all.each{|item| prefectures[item.name] = item }
      # p prefectures

      responses.each {|event|

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
        spot.body        = event["descs"].first unless event["descs"].nil?
        spot.longitude   = event.dig("place", "coordinates", "longitude")
        spot.latitude    = event.dig("place", "coordinates", "longitude")
        spot.zip         = event.dig("place", "postal_code")
        spot.active_term = event.dig("visit", "service", "open")

        # ジャンル
        api_genres = event.dig("genres")
        spot_genres = []
        Array(api_genres).each_with_index{|item, index|
          genre_l = Genre.where("name = ? and parent_id is null", item["L"]).first

          


          genre_l.genres.each{|genre_m|

            if genre_m.name == item["M"]
                genre_m.genres.map{|genre_s|
                if genre_s.name == item["S"]
                  main_flg = index ==0 ? 1 : 0
                  spot_genre = SpotGenre.new({genre_id: genre_m.id, level: index, main: main_flg})
                  spot_genres << spot_genre
                end
              }
            end
          }
        }
        spot.spot_genres = spot_genres

        # 連絡先
        spot.prefecture = prefectures[event.dig("place", "pref", "written")]
        spot.city     = event["place"]["city"]["written"]
        spot.address1 = event.dig("place", "street", "written")
        spot.address2 = event.dig("place", "building", "written")
        spot.tel      = event.dig("place", "phone")
        spot.fax      = event.dig("place", "fax")
        spot.email    = event.dig("place", "email")
        spot.url      = event.dig("url")

        # 画像情報
        unless event.dig("views").nil?
          event_info = event.dig("views").first
          spot.image_url           = event_info.dig("fid")
          spot.image_copyright     = event_info.dig("copyright")
          spot.image_name          = event_info.dig("name", "written")
          spot.image_spoken        = event_info.dig("name", "spoken")
          spot.image_shooting_date = event_info.dig("when")
        end

        # スポット詳細
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
        spot.spot_detail = detail

        # 開催期間
        periods = event.dig("visit", "service", "periods")
        spot_terms = []
        spot_terms = Array(periods).map{|item|
          spot_term = SpotTerm.new
          spot_term.season = item.dig("season")
          spot_term.open_date = item.dig("st_date")
          spot_term.close_date = item.dig("en_date")
          spot_term.day_of_week = item.dig("day_of_week")
          spot_term.hour = item.dig("hours")
          spot_term.info = item.dig("note")
        }
        spot.spot_terms = spot_terms

        # 登録処理
        begin
          Spot.transaction do
            spot.save!
            p "commit OK spotid:#{spot.id}"
          end
        rescue => e
          Rails.logger.fatal(e)
          p e
          next
        end
      }


  end

end
