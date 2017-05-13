require 'rails_helper'
include Api::Atnd

describe AtndApi, type: :request do
  let(:api) { AtndApi }
  it '１ページ(１００件以内)の場合', vcr: '#search-1page' do
    events = api.search(keyword: '名古屋', ym: '201701')
    expect(events.count).to be < 100
    expect(events.uniq.size).to eq events.size
  end

  it '２ページ(１００件以上)の場合', vcr: '#search-2page' do
    events = api.search(keyword: '名古屋', ym: ['201611', '201612', '201701'])
    expect(events.count).to be > 100
    expect(events.uniq.size).to eq events.size
  end

  it '３ページ(２００件以上)の場合', vcr: '#search-3page' do
    events = api.search(keyword: '名古屋', ym: ['201608', '201609', '201610', '201611', '201612', '201701'])
    expect(events.count).to be > 200
    expect(events.uniq.size).to eq events.size
  end

  it 'イベントIDを指定した場合', vcr: '#search-event_id' do
    events = api.search(event_id: 81945)
    expect(events.first.title).to eq 'エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！成長し続けるWebサービスの裏側 AWS活用事例を大公開！'
  end

  it '#find', vcr: '#find' do
    event = api.find(event_id: 81945)
    expect(event.title).to eq 'エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！成長し続けるWebサービスの裏側 AWS活用事例を大公開！'
  end
end
