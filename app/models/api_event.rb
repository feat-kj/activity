require 'uri'

class ApiEvent
  include ActiveModel::Model

  attr_accessor :genre, :code, :coordinates, :facility,:name, :place, :desc, :limit, :skip,
                :latitude, :londitude, :distance, :genres

  @@limit = 50

  def find_recently
    # 行事・祭事;花見;郷土芸能;その他（イベント）
    self.genre = '%e8%a1%8c%e4%ba%8b%e3%83%bb%e7%a5%ad%e4%ba%8b%3b%e8%8a%b1%e8%a6%8b%3b%e9%83%b7%e5%9c%9f%e8%8a%b8%e8%83%bd%3b%e3%81%9d%e3%81%ae%e4%bb%96%ef%bc%88%e3%82%a4%e3%83%99%e3%83%b3%e3%83%88%ef%bc%89'
    self.limit = 6
    self.find_from_api
  end

  def find_popular
    # 城郭;旧街道;史跡;歴史的建造物;近代的建造物;博物館;美術館;動・植物園;水族館;神社・仏閣等;道の駅（見る）;その他（特殊地形）
    self.genre = '%e5%9f%8e%e9%83%ad%3b%e6%97%a7%e8%a1%97%e9%81%93%3b%e5%8f%b2%e8%b7%a1%3b%e6%ad%b4%e5%8f%b2%e7%9a%84%e5%bb%ba%e9%80%a0%e7%89%a9%3b%e8%bf%91%e4%bb%a3%e7%9a%84%e5%bb%ba%e9%80%a0%e7%89%a9%3b%e5%8d%9a%e7%89%a9%e9%a4%a8%3b%e7%be%8e%e8%a1%93%e9%a4%a8%3b%e5%8b%95%e3%83%bb%e6%a4%8d%e7%89%a9%e5%9c%92%3b%e6%b0%b4%e6%97%8f%e9%a4%a8%3b%e7%a5%9e%e7%a4%be%e3%83%bb%e4%bb%8f%e9%96%a3%e7%ad%89%3b%e9%81%93%e3%81%ae%e9%a7%85%ef%bc%88%e8%a6%8b%e3%82%8b%ef%bc%89%3b%e3%81%9d%e3%81%ae%e4%bb%96%ef%bc%88%e7%89%b9%e6%ae%8a%e5%9c%b0%e5%bd%a2%ef%bc%89'
    self.limit = 6
    self.find_from_api
  end

  def find_near
    # 行事・祭事;花見;郷土芸能;その他（イベント）
    # self.genre = '%e8%a1%8c%e4%ba%8b%e3%83%bb%e7%a5%ad%e4%ba%8b%3b%e8%8a%b1%e8%a6%8b%3b%e9%83%b7%e5%9c%9f%e8%8a%b8%e8%83%bd%3b%e3%81%9d%e3%81%ae%e4%bb%96%ef%bc%88%e3%82%a4%e3%83%99%e3%83%b3%e3%83%88%ef%bc%89'
    self.genre = '%e8%a1%8c%e4%ba%8b%e3%83%bb%e7%a5%ad%e4%ba%8b;%e8%8a%b1%e8%a6%8b'
    self.limit = 3
    latitude   = '135.6777666'
    londitude  = '35.0129601'
    distance   = '50000'
    # conditons[:coordinates] = '135.6777666,35.0129601,50000'

    self.find_from_api
  end

  def find_feature
    # 特集 [郷土料理店;その他（食べる）;ショッピング店;伝統工芸技術;その他（買う）;産業観光施設]
    self.genre = '%e9%83%b7%e5%9c%9f%e6%96%99%e7%90%86%e5%ba%97%3b%e3%81%9d%e3%81%ae%e4%bb%96%ef%bc%88%e9%a3%9f%e3%81%b9%e3%82%8b%ef%bc%89%3b%e3%82%b7%e3%83%a7%e3%83%83%e3%83%94%e3%83%b3%e3%82%b0%e5%ba%97%3b%e4%bc%9d%e7%b5%b1%e5%b7%a5%e8%8a%b8%e6%8a%80%e8%a1%93%3b%e3%81%9d%e3%81%ae%e4%bb%96%ef%bc%88%e8%b2%b7%e3%81%86%ef%bc%89%3b%e7%94%a3%e6%a5%ad%e8%a6%b3%e5%85%89%e6%96%bd%e8%a8%ad'
    self.limit = 3
    self.find_from_api
  end

  def find_from_api
    url    = AppConfig.api.url
    format = AppConfig.api.format
    conditons = self.create_conditions
    keyword   = self.genre

    conn = Faraday.new(:url => url) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.response :json, :content_type => /\bjson$/
      faraday.adapter  Faraday.default_adapter
    end

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

  def create_conditions
    conditions = {}
    conditions[:code]        = self.code
    conditions[:coordinates] = self.coordinates

    # puts self.facility.kind_of?(Array)
    # if self.name.kind_of?(Array)
    # puts self.place.kind_of?(Array)

    conditions[:facility]    = self.facility
    conditions[:name]        = self.name
    conditions[:place]       = self.place
    conditions[:desc]        = self.desc
    conditions[:skip]        = self.skip
    conditions[:limit]       = self.limit

    if conditions[:limit].blank?
      conditions[:limit] = @@limit
    end
    return conditions
  end

  # パラメータをUTF8にエンコードする
  def parameter_convert(param)
    if param.blank?
      return param
    end
    if param.kind_of?(Array)
      before_encode = param.join(";")
      return URI.escape(before_encode)
    end

    return URI.escape(param)
  end

end
