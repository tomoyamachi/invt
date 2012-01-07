# -*- coding: utf-8 -*-
# Load the rails application
require File.expand_path('../application', __FILE__)
IVNT_TYPE = ["誕生日","誕生日(サプライズ)","ディナー/飲み会","結婚/出産祝い","スポーツ/ライブ","イベント","映画/TV","ショッピング","ランチ","ミーティング","その他"]

FRIENDS_PER_PAGE = 50

FACEBOOK_APP_ID = "170649486355496"

EVENT_STATUS = ["まだ決まってません","決定しています","終了しました"]
SCHEDULE_STATUS = ["まだ決まっていません","この日に決定しました","他の日に決定されました"]
EVENT_RANK = ["できれば避けたい","この日でも大丈夫","この日だと嬉しい"]
DIALOG_PICTURE_URI = "http://www.invt.biz/images/logo64.png"
DIALOG_DESCRIPTION = "INVTは、みんなのスケジュールを直観的に合わせるためのサービスです。INVTを使うと、面倒なスケジュール合わせを、自動でやってしまえます。"
SITE_URI = "http://www.invt.biz/"
# Initialize the rails application
Invt::Application.initialize!
