require 'test_helper'
module Backend
  module Visualizations
    class LandParcelsVisualizationsControllerTest < ActionController::TestCase
      setup do
        Ekylibre::Tenant.switch!('test')
        @locale = ENV['LOCALE'] || I18n.default_locale
        @user = users(:users_001)
        @user.update_column(:language, @locale)
        sign_in(@user)
      end

      teardown do
        sign_out(@user)
      end

      test 'async loading land parcels visualization' do
        land_parcels = LandParcel.all
        expected_land_parcels_count = land_parcels.count

        get :show, xhr: true, format: :json
        r = JSON.parse(@response.body)

        assert r.key? 'series'
        assert r['series'].key? 'main'
        assert_equal expected_land_parcels_count, r['series']['main'].count

        assert_equal land_parcels.first.name, r['series']['main'].first['name']
        assert_equal land_parcels.first.shape.to_json_object, r['series']['main'].first['shape']
      end
    end
  end
end
