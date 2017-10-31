require 'rails_helper'

RSpec.describe ApiEvent, type: :model do

  # エンコードテスト
  describe '#model parameter_convert' do
    before do
      @events = ApiEvent.new
    end
    context '値が文字列の場合' do
      str = 'テスト'
      it "URLエンコード文字列が返される" do
        encode = @events.parameter_convert(str)
        expect(encode).to eq '%E3%83%86%E3%82%B9%E3%83%88'
      end
    end
    context '値が配列の場合(区切り文字デフォ)' do
      arr = ['テスト', 'URLエンコード']
      it "{,}で結合されたURLエンコード文字列が返される" do
        encode = @events.parameter_convert(arr)
        expect(encode).to eq '%E3%83%86%E3%82%B9%E3%83%88,URL%E3%82%A8%E3%83%B3%E3%82%B3%E3%83%BC%E3%83%89'
      end
    end
    context '値が配列の場合(区切り文字指定{;})' do
      arr = ['テスト', 'URLエンコード']
      delimiter = ';'
      it "{;}で結合されたURLエンコード文字列が返される" do
        encode = @events.parameter_convert(arr, delimiter)
        expect(encode).to eq '%E3%83%86%E3%82%B9%E3%83%88;URL%E3%82%A8%E3%83%B3%E3%82%B3%E3%83%BC%E3%83%89'
      end
    end
  end

  # 条件作成テスト
  describe '#model create_conditions' do
    context '付帯設備が設定されいる場合' do
      events = ApiEvent.new
      events.facility = '点字'
      it "付帯設備にエンコード文字列が設定される" do
        conditions = events.create_conditions
        expect(conditions[:facility]).to eq '%E7%82%B9%E5%AD%97'
      end
    end
    context '名称が設定されている場合' do
      events = ApiEvent.new
      events.name = 'ひまわり村'
      it "名称にエンコード文字列が設定される" do
        conditions = events.create_conditions
        expect(conditions[:name]).to eq '%E3%81%B2%E3%81%BE%E3%82%8F%E3%82%8A%E6%9D%91'
      end
    end
    context '所在地が設定されている場合' do
      events = ApiEvent.new
      events.place = '京都府'
      it "所在地にエンコード文字列が設定される" do
        conditions = events.create_conditions
        expect(conditions[:place]).to eq '%E4%BA%AC%E9%83%BD%E5%BA%9C'
      end
    end
    context '座標情報が不足している場合' do
      events = ApiEvent.new
      events.latitude  = '135.6777666'
      events.distance  = '50000'

      it "座標情報に何も設定されない" do
        conditions = events.create_conditions
        expect(conditions[:coordinates]).to eq nil
      end
    end
    context '座標が設定されている場合' do
      events = ApiEvent.new
      events.latitude  = '135.6777666'
      events.longitude = '35.0129601'
      events.distance  = '50000'
      it "座標情報が{,}で結合された文字列が設定される" do
        conditions = events.create_conditions
        expect(conditions[:coordinates]).to eq '135.6777666,35.0129601,50000'
      end
    end
  end

end
