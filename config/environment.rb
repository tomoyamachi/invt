# -*- coding: utf-8 -*-
# Load the rails application
require File.expand_path('../application', __FILE__)
IVNT_TYPE = ["誕生日","誕生日(サプライズ)","ディナー/飲み会","結婚/出産祝い","スポーツ/ライブ","イベント","映画/TV","ショッピング","ランチ","ミーティング","その他"]

FRIENDS_PER_PAGE = 50

FACEBOOK_APP_ID = "170649486355496"

EVENT_STATUS = ["まだ決まってません","決定しています","終了しました"]
EVENT_RANK = ["できれば避けたい","この日でも大丈夫","この日だと嬉しい"]
# Initialize the rails application
Invt::Application.initialize!
