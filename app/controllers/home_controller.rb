class HomeController < ApplicationController
  def index
    @recentlies = ApiEvent.find_recently
    @populars   = ApiEvent.find_popular
    features   = ApiEvent.find_feature
    @features_main = features[0]
    @features      = [features[1],features[2]]
  end
end
