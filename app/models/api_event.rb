require 'uri'

class ApiEvent
  include ActiveModel::Model

  attr_accessor :genre, :code, :coordinates, :facility, :name, :place, :desc, :limit, :skip,
                :latitude, :longitude, :distance, :genres

  @@limit = 50

  # ベースジャンルを作成
  def create_genre
    return parameter_convert(self.genre, ';')
  end

  # 検索条件を作成
  def create_conditions
    conditions = {}
    conditions[:code]     = self.code
    conditions[:facility] = parameter_convert(self.facility)
    conditions[:name]     = parameter_convert(self.name)
    conditions[:place]    = parameter_convert(self.place)
    conditions[:desc]     = parameter_convert(self.desc)
    # 範囲は緯度経度距離全てそろって、有効
    if self.latitude.present? && self.longitude.present? && self.distance.present?
      tmp = [self.latitude, self.longitude, self.distance]
      conditions[:coordinates] = tmp.join(',')
    end
    conditions[:skip]  = self.skip
    conditions[:limit] = self.limit
    if conditions[:limit].blank?
      conditions[:limit] = @@limit
    end
    return conditions
  end

  # 値をUTF8文字列にエンコードする (配列の場合はdelimiterで結合する)
  def parameter_convert(param, delimiter=',')
    if param.blank?
      return param
    end
    if param.kind_of?(Array)
      encode_param = param.map {|param_value| URI.escape(param_value)}
      return encode_param.join(delimiter)
    end
    return URI.escape(param)
  end

  class << self
    # イベント情報をAPIから取得する
    def find_from_api(api_event_model)
      url        = AppConfig.api.url
      format     = AppConfig.api.format
      keyword    = api_event_model.create_genre
      conditons  = api_event_model.create_conditions

      ## 接続情報設定
      conn = Faraday.new(:url => url) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.response :json, :content_type => /\bjson$/
        faraday.adapter  Faraday.default_adapter
      end

      ## 接続パラメータ設定
      json_response = conn.get do |req|
        req.url "kanko/#{keyword}/#{format}"
        conditons.keys.each do |pram_key|
          if conditons[pram_key].present?
            req.params[pram_key] = conditons[pram_key]
          end
        end
      end
      results = JSON.parse(json_response.body)
      return results['tourspots']
    end

    # 最新のイベントを取得する
    def find_recently
      events = ApiEvent.new
      # 行事・祭事;花見;郷土芸能;その他（イベント）
      events.genre = ['行事・祭事', '花見', '郷土芸能', 'その他（イベント）']
      events.limit = 6
      ApiEvent.find_from_api(events)
    end

    # 人気のイベントを取得する
    def find_popular
      events = ApiEvent.new
      # 城郭;旧街道;史跡;歴史的建造物;近代的建造物;博物館;美術館;動・植物園;水族館;神社・仏閣等;道の駅（見る）;その他（特殊地形）
      events.genre = ['城郭', '旧街道', '史跡', '歴史的建造物', '近代的建造物', '博物館', '美術館', '動・植物園', '水族館', '神社・仏閣等', '道の駅（見る）', 'その他（特殊地形）']
      events.limit = 6
      ApiEvent.find_from_api(events)
    end

    # 近くのイベントを取得する
    def find_near(latitude:lat, longitude:lon)
      events = ApiEvent.new
      # 行事・祭事;花見;郷土芸能;その他（イベント）
      events.genre = ['行事・祭事', '花見', '郷土芸能', 'その他（イベント）']
      events.limit = 3
      events.latitude  = lat #'135.6777666'
      events.longitude = lon #'35.0129601'
      events.distance  = '50000'
      ApiEvent.find_from_api(events)
    end

    # 特集イベントを取得する
    def find_feature
      events = ApiEvent.new
      # 特集 [郷土料理店;その他（食べる）;ショッピング店;伝統工芸技術;その他（買う）;産業観光施設]
      events.genre = ['郷土料理店', 'その他（食べる）', 'ショッピング店', '伝統工芸技術', 'その他（買う）', '産業観光施設']
      events.limit = 3
      ApiEvent.find_from_api(events)
    end

    # 単体イベントを取得する
    def find_by_name (genre: '', name: '')
      events = ApiEvent.new
      events.genre = genre
      events.name  = name
      events.limit = 1
      ApiEvent.find_from_api(events)
    end
  end
end
