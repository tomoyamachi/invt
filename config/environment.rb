# -*- coding: utf-8 -*-
# Load the rails application
require File.expand_path('../application', __FILE__)
IVNT_TYPE = ["誕生日","誕生日(サプライズ)","ディナー/飲み会","結婚/出産祝い","スポーツ/ライブ","イベント","映画/TV","その他"]

FRIENDS_PER_PAGE = 10

# Initialize the rails application
Invt::Application.initialize!
