module Api
  module Atnd
    module AtndScraping
      def group_url
        group_info do |doc|
          href = doc.css('a/@href').text
          "https://atnd.org#{href}"
        end
      end

      def group_id
        group_info do |doc|
          href = doc.css('a/@href').text
          href.gsub(/.*\//, '')
        end
      end

      def group_title
        group_info do |doc|
          doc.css('a').text
        end
      end

      def group_logo_url
        group_info do |doc|
          src = doc.css('img/@src').text
          "https://atnd.org#{src}"
        end
      end

      def logo_url
        event_doc.css('.events-show-img > img/@data-original').each do |img|
          return "https://atnd.org#{img}"
        end
        'atnd.png'
      end

      def users
        event_doc.css('#members-join ol li span').map { |user|
          img = user.css('img/@data-original')
          image_url = ''
          if img.present?
            image_url = "https:#{img}" if img !~ /https/
          else
            image_url = 'https://atnd.org/images/icon/default_latent.png'
          end
          id = user.css('a/@href').text.gsub('/users/', '')
          name = user.css('a').text
          social_ids = get_social_id(id)
          AtndUser.new(social_ids.merge(atnd_id: id, name: name, image_url: image_url))
        }.sort_by { |user| user.twitter_id }.reverse
      end

      def owners
        owner_info = event_doc.css('#user-id')
        return [] if owner_info.empty?

        src = event_doc.css('.events-show-info img/@src').text
        image_url = (src == '/images/icon/default_latent.png') ? "https://atnd.org#{src}" : "https:#{src}"

        id = owner_info.attribute('href').value.gsub('/users/', '')
        social_ids = get_social_id(id)

        [AtndUser.new(social_ids.merge(atnd_id: id, name: owner_nickname, image_url: image_url))]
      end

      private

      def group_info
        event_doc.css('.events-show-info > dl').each do |doc|
          return yield doc if doc.css('dt').text == '主催グループ :'
        end
        nil
      end

      def get_social_id(user_id)
        user_url = "https://atnd.org/users/#{user_id}"
        user_doc = Api::Http.get_document(user_url, false)

        users_show_info = user_doc.css('#users-show-info')
        twitter_id = users_show_info.css('dl:nth-child(2) dd a').text
        facebook_id = users_show_info.css('dl:nth-child(3) dd').text

        twitter_id = nil if twitter_id == '-'
        facebook_id = nil if facebook_id == '-'

        { twitter_id: twitter_id, facebook_id: facebook_id }
      end

      def event_doc
        @event_doc ||= Api::Http.get_document(event_url, false)
      end
    end
  end
end
