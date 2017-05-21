require 'rails_helper'
include Api::Connpass

describe ConnpassScraping, type: :request do
  let(:api) { ConnpassApi }
  describe '#find' do
    # JXUGC #14 Xamarin ハンズオン 名古屋大会 https://jxug.connpass.com/event/30152/
    let(:event) { api.find(event_id: 30152) }
    it 'イベントが取得できること', vcr: '#find' do
      expect(event.source).to eq 'connpass'
      expect(event.event_id).to eq 30152
      expect(event.event_url).to eq 'https://jxug.connpass.com/event/30152/'
      expect(event.title).to eq 'JXUGC #14 Xamarin ハンズオン 名古屋大会'
      expect(event.logo).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/d7/3c/d73cccc993bb52bffbc0b65bc4c10d38.png'
      expect(event.catch).to start_with 'にゃごやでも話題の Xamarin を触ってみよう！<br>こんにちは。エクセルソフトの田淵です。 今話題の Xamarin を名古屋でも触ってみましょう！'
      expect(event.started_at).to eq Date.parse('2016-05-15T13:00:00+09:00')
      expect(event.place).to eq '熱田生涯学習センター'
      expect(event.address).to eq '熱田区熱田西町2-13'
      expect(event.group_title).to eq 'JXUG'
      expect(event.group_id).to eq 1134
      expect(event.group_url).to eq 'https://jxug.connpass.com/'
      expect(event.group_logo).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/c9/d3/c9d379a73fa278df5fae314abd0d227a.png'
      expect(event.limit_over?).to eq true
      expect(event.accepted).to eq event.users.count
    end
  end

  describe '#users' do
    # JXUGC #14 Xamarin ハンズオン 名古屋大会 https://jxug.connpass.com/event/30152/
    let(:event) { api.find(event_id: 30152) }
    let(:users) { event.users }
    it '参加者数が取得できること', vcr: '#users' do
      expect(users.count).to eq event.accepted
    end

    context 'shuleの場合', vcr: '#users-shule' do
      let(:shule) { users.select { |user| user.connpass_id == 'shule517' }.first }
      it { expect(shule.connpass_id).to eq 'shule517' }
      it { expect(shule.twitter_id).to eq 'shule517' }
      it { expect(shule.facebook_id).to eq '' }
      it { expect(shule.github_id).to eq 'shule517' }
      it { expect(shule.linkedin_id).to eq '' }
      it { expect(shule.name).to eq 'シュール' }
      it { expect(shule.image_url).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/b9/93/b99305b6784e742244868ddd5acc8646.png' }
    end

    context 'kuuの場合', vcr: '#users-kuu' do
      let(:kuu) { users.select { |user| user.connpass_id == 'Kuxumarin' }.first }
      it { expect(kuu.connpass_id).to eq 'Kuxumarin' }
      it { expect(kuu.twitter_id).to eq 'Fumiya_Kume' }
      it { expect(kuu.facebook_id).to eq '1524732281184852' }
      it { expect(kuu.github_id).to eq 'fumiya-kume' }
      it { expect(kuu.linkedin_id).to eq '' }
      it { expect(kuu.image_url).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/75/1f/751ff2dde8d0e259e4ad95c77bcda057.png' }
    end

    describe '#user.image_url', vcr: '#users.image_url' do
      context 'ユーザ画像が設定されている場合'
      context 'ユーザ画面が設定されていない場合'
      context 'httpsからはじまる場合'
      context 'httpsからはじまらない場合'
    end

    context '参加者がいない場合'
    context '参加者ページがある場合' do
      # it { expect(kuu.connpass_id).to eq 'Kuxumarin' }
      # it { expect(kuu.twitter_id).to eq 'Fumiya_Kume' }
      # it { expect(kuu.facebook_id).to eq '' }
      # it { expect(kuu.github_id).to eq '' }
      # it { expect(kuu.linkedin_id).to eq '' }
      # it { expect(kuu.image_url).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/75/1f/751ff2dde8d0e259e4ad95c77bcda057.png' }
    end
    context '参加者ページがない場合' do
      # it { expect(kuu.connpass_id).to eq 'Kuxumarin' }
      # it { expect(kuu.twitter_id).to eq 'Fumiya_Kume' }
      # it { expect(kuu.facebook_id).to eq '' }
      # it { expect(kuu.github_id).to eq '' }
      # it { expect(kuu.linkedin_id).to eq '' }
      # it { expect(kuu.image_url).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/75/1f/751ff2dde8d0e259e4ad95c77bcda057.png' }
    end
  end

  describe '#owners', vcr: '#owners' do
    # JXUGC #14 Xamarin ハンズオン 名古屋大会 https://jxug.connpass.com/event/30152/
    let(:event) { api.find(event_id: 30152) }
    let(:owners) { event.owners }
    it '管理者数が取得できること' do
      expect(owners.count).to eq 4
    end
    it '管理者一覧が取得できること' do
      expect(owners.map(&:name)).to match_array %w(田淵義人@エクセルソフト JXUG くぅ\ -\ kuxu Sophy)
    end

    context '参加者ページがある場合' do
      # it { expect(kuu.connpass_id).to eq 'Kuxumarin' }
      # it { expect(kuu.twitter_id).to eq 'Fumiya_Kume' }
      # it { expect(kuu.facebook_id).to eq '' }
      # it { expect(kuu.github_id).to eq '' }
      # it { expect(kuu.linkedin_id).to eq '' }
      # it { expect(kuu.image_url).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/75/1f/751ff2dde8d0e259e4ad95c77bcda057.png' }
    end
    context '参加者ページがない場合' do
      # it { expect(kuu.connpass_id).to eq 'Kuxumarin' }
      # it { expect(kuu.twitter_id).to eq 'Fumiya_Kume' }
      # it { expect(kuu.facebook_id).to eq '' }
      # it { expect(kuu.github_id).to eq '' }
      # it { expect(kuu.linkedin_id).to eq '' }
      # it { expect(kuu.image_url).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/75/1f/751ff2dde8d0e259e4ad95c77bcda057.png' }
    end
    context 'owner_info.empty?の場合'
    context '画像が設定されている場合'
    context '画像が設定されていない場合'
    context '管理者がいない場合'
  end

  describe '#catch' do
    context 'キャッチコピーが存在する場合', vcr: '#catch-catch_exist' do
      # 機械学習 名古屋 分科会 #2 https://machine-learning.connpass.com/event/55649/
      let(:event) { api.find(event_id: 55649) }
      it { expect(event.catch).to start_with 'ゼロから作る Deep Learning 読書会＋ハンズオン その2<br>機械学習 名古屋 分科会 機械学習名古屋 勉強会の分科会です。 この分科会では、より理論・実装に重きを置いた勉強をしていきます。' }
    end
    context 'キャッチコピーが存在しない場合', vcr: '#catch-catch_not_exist' do
      # 遺伝的有限集合勉強会 7 https://connpass.com/event/55925/
      let(:event) { api.find(event_id: 55925) }
      it { expect(event.catch).to start_with '概要 HFと有限の世界を勉強しましょう。 第7回は[1]のIV.5.9、第一不完全性定理のあたりを読みます. 予習不要' }
    end
  end

  describe '#logo' do
    let(:logo) { event.logo }
    context 'logoが設定されている場合' do
      # JXUGC #14 Xamarin ハンズオン 名古屋大会 https://jxug.connpass.com/event/30152/
      let(:event) { api.find(event_id: 30152) }
      it '設定されたロゴが取得できること', vcr: '#logo.exist' do
        expect(logo).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/d7/3c/d73cccc993bb52bffbc0b65bc4c10d38.png'
      end
    end
    context 'logoが設定されていない場合' do
      # 遺伝的有限集合勉強会 8 https://connpass.com/event/57258/
      let(:event) { api.find(event_id: 57258) }
      it 'connpassのロゴが取得できること', vcr: '#logo.not_exist' do
        expect(logo).to eq 'https://connpass.com/static/img/468_468.png'
      end
    end
  end

  describe '#get_social_id' do
    let(:users) { event.users }
    describe '#twitter_id' do
      context 'twitter_idが設定されている場合', vcr: '#get_social_id twitter_id exist' do
        # JXUGC #14 Xamarin ハンズオン 名古屋大会 https://jxug.connpass.com/event/30152/
        let(:event) { api.find(event_id: 30152) }
        let(:user) { users.select { |user| user.connpass_id == 'Kuxumarin' }.first }
        it { expect(user.twitter_id).to eq 'Fumiya_Kume' }
      end
      context 'twitter_idが設定されていない場合', vcr: '#get_social_id twitter_id not_exist' do
        # JXUGC #14 Xamarin ハンズオン 名古屋大会 https://jxug.connpass.com/event/30152/
        let(:event) { api.find(event_id: 30152) }
        let(:user) { users.select { |user| user.connpass_id == 'h_aka' }.first }
        it { expect(user.twitter_id).to be_empty }
      end
    end
    describe '#facebook_id' do
      context 'facebook_idが設定されている場合', vcr: '#get_social_id facebook_id exist' do
        # JXUGC #14 Xamarin ハンズオン 名古屋大会 https://jxug.connpass.com/event/30152/
        let(:event) { api.find(event_id: 30152) }
        let(:user) { users.select { |user| user.connpass_id == 'Kuxumarin' }.first }
        it { expect(user.facebook_id).to eq '1524732281184852' }
      end
      context 'facebook_idが設定されていない場合', vcr: '#get_social_id facebook_id not_exist' do
        # JXUGC #14 Xamarin ハンズオン 名古屋大会 https://jxug.connpass.com/event/30152/
        let(:event) { api.find(event_id: 30152) }
        let(:user) { users.select { |user| user.connpass_id == 'shule517' }.first }
        it { expect(user.facebook_id).to be_empty }
      end
    end
    describe '#github_id' do
      context 'github_idが設定されている場合', vcr: '#get_social_id github_id exist' do
        # JXUGC #14 Xamarin ハンズオン 名古屋大会 https://jxug.connpass.com/event/30152/
        let(:event) { api.find(event_id: 30152) }
        let(:user) { users.select { |user| user.connpass_id == 'Kuxumarin' }.first }
        it { expect(user.github_id).to eq 'fumiya-kume' }
      end
      context 'github_idが設定されていない場合', vcr: '#get_social_id github_id not_exist' do
        # JXUGC #14 Xamarin ハンズオン 名古屋大会 https://jxug.connpass.com/event/30152/
        let(:event) { api.find(event_id: 30152) }
        let(:user) { users.select { |user| user.connpass_id == 'h_aka' }.first }
        it { expect(user.github_id).to be_empty }
      end
    end
  end

  describe '#participation_url' do
    context 'group_urlがない場合', vcr: '#participation_url group_url-exist' do
      # サブドメイン → connpass.com
      # ちゅーんさんちでHaskellやると楽しいという会 https://connpass.com/event/46087/
      let(:event) { api.find(event_id: 46087) }
      it { expect(event.send(:participation_url)).to eq 'https://connpass.com/event/46087/participation/#participants' }
    end
    context 'group_url.nilじゃない場合', vcr: '#participation_url group_url-not_exist' do
      # ドメイン → jxug.connpass.com
      # JXUGC #14 Xamarin ハンズオン 名古屋大会 https://jxug.connpass.com/event/30152/
      let(:event) { api.find(event_id: 30152) }
      it { expect(event.send(:participation_url)).to eq 'https://jxug.connpass.com/event/30152/participation/#participants' }
    end
  end

  context 'group_urlがない場合', vcr: '#find-no_group' do
    # ちゅーんさんちでHaskellやると楽しいという会 https://connpass.com/event/46087/
    let(:event) { api.find(event_id: 46087) }
    it '参加者人数が取得できること' do
      expect(event.users.count).to eq event.accepted
    end
    it '主催者人数が取得できること' do
      expect(event.owners.count).to eq 1
    end
  end

  context 'Python東海の参加者数が0である問題を解決', vcr: '#find-no_users' do
    # Python東海 第32回勉強会 https://connpass.com/event/49376/
    let(:event) { api.find(event_id: 49376) }
    it '参加者人数が取得できること' do
      expect(event.users.count).to eq event.accepted
    end
  end

  context 'チョコ meets ワインの参加者数が足りてない問題を解決', vcr: '#find-less_users' do
    # チョコ meets ワイン https://connpass.com/event/51037/
    let(:event) { api.find(event_id: 51037) }
    it '参加者人数が取得できること' do
      expect(event.users.count).to eq event.accepted
    end

    it '主催者人数が取得できること' do
      expect(event.owners.count).to eq 1
    end
  end
end
