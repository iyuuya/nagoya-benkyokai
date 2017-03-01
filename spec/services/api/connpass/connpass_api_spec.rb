require 'rails_helper'
include Api::Connpass
describe ConnpassApi do
  let(:api) { ConnpassApi.new }
  it '１ページ(１００件以内)の場合' do
    result = api.search(keyword: '名古屋', ym: '201701')
    expect(result.count).to be < 100
  end
  it '２ページ(１００件以上)の場合' do
    result = api.search(keyword: '名古屋', ym: ['201610', '201611'])
    expect(result.count).to be >= 100
  end
  it '３ページ(２００件以上)の場合' do
    result = api.search(keyword: ['愛知', '名古屋'], ym: ['201610', '201611', '201612', '201701'])
    expect(result.count).to be >= 200
  end
end
