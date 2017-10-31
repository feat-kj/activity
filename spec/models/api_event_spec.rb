require 'rails_helper'

RSpec.describe ApiEvent, type: :model do

  # API接続テスト
  describe '#model validate' do
    context 'codeがtestの場合' do
      events = ApiEvent.new
      events.code = 'test'
      it "条件にtestが設定される" do
        conditions = events.create_conditions
        expect(conditions[:code]).to eq 'test'
      end
    end
  end

  # API接続テスト
  describe '#model validate' do
    context 'nameが配列の場合' do
      events = ApiEvent.new
      events.name = ['test','test2']
      it "条件に配列が設定される" do
        conditions = events.create_conditions
        expect(conditions[:name]).to eq ['test','test2']
      end
    end
  end

  # API接続テスト
  describe '#model validate' do
    context 'ジャンルに値があるばあい' do
      events = ApiEvent.new
      events.genre = 'お祭り'
      it "条件に配列が設定される" do
        result = events.parameter_convert(events.genre).downcase
        expect(result).to eq '%e3%81%8a%e7%a5%ad%e3%82%8a'
      end
      # events.genre = ['お祭り', '花火']
      # it "条件に配列が設定される" do
      #   result = events.parameter_convert(events.genre).downcase
      #   expect(result).to eq '%e3%81%8a%e7%a5%ad%e3%82%8a%3b%e8%8a%b1%e7%81%ab'
      # end
    end
  end
end
