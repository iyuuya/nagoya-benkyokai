require 'rails_helper'

describe UpdateTwitterListService, type: :request do
  include EventHelper

  let(:twitter) { TwitterClient.new }
  let(:target_event) { Api::Atnd::AtndApi.find(event_id: 81945) }
  it 'リストを作成すること', vcr: 'create' do
    event = StoreEventService.new.call(target_event)
    event.started_at = Time.now
    set_event(event, started_at: Time.now)

    service = UpdateTwitterListService.new
    service.call(event)
    expect(service.send(:exists_list?)).to eq true
    expect(twitter.list_exists?(twitter_url)).to eq true
    expect(list.name).to eq 'エイチームの開発勉強会『ATEAM TECH』'
    expect(list.description).to eq '2017/5/20(土) エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！成長し続けるWebサービスの裏側 AWS活用事例を大公開！'
    expect(list.member_count).to eq 6
  end

  it 'リストの更新ができること', vcr: 'update' do
    event = StoreEventService.new.call(target_event)
    event.started_at = Time.now
    set_event(event, started_at: Time.now)

    service = UpdateTwitterListService.new
    service.call(event)
    expect(service.send(:exists_list?)).to eq true
    expect(twitter.list_exists?(twitter_url)).to eq true
    expect(list.name).to eq 'エイチームの開発勉強会『ATEAM TECH』'
    expect(list.description).to eq '2017/5/20(土) エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！成長し続けるWebサービスの裏側 AWS活用事例を大公開！'
    expect(list.member_count).to eq 6

    set_event(event, title: '更新『ATEAM TECH』', started_at: Time.now)
    service = UpdateTwitterListService.new
    service.call(event)
    expect(service.send(:exists_list?)).to eq true
    expect(list.name).to eq '更新『ATEAM TECH』'
    expect(list.description).to eq '2017/5/20(土) 更新『ATEAM TECH』'
    expect(list.member_count).to eq 6
  end
end
