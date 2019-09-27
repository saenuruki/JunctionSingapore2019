//
//  Event.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/27.
//  Copyright © 2019 塗木冴. All rights reserved.
//

import UIKit
import ObjectMapper

struct Event: Mappable {
    var id: String = ""
    var name: String = ""
    var area: String = ""
    var imageURLString: String = ""
    var description: String = ""
    
    init() {}
    init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        area <- map["area"]
        imageURLString <- map["imageURLString"]
        description <- map["description"]
    }
}

let eventsSample: [[String: Any]] =
    [[
        "id":"1",
        "name":"ハンバーガー1つ無料",
        "area":"2F MacDonald",
        "imageURLString":"https://s3-ap-northeast-1.amazonaws.com/mag.nearly.do/item_getties/images/000/135/351/medium/8b1a2f53-5937-42ca-88bc-e63098c137f5.jpg",
        "description":"有効期限：2019年12月10日"
        ],
     [
        "id":"2",
        "name":"駐車券無料",
        "area":"駐車エリア",
        "imageURLString":"https://cdn-ak.f.st-hatena.com/images/fotolife/N/NANTONAKU_everyday/20160618/20160618160803.jpg",
        "description":"有効期限：2019年12月10日"
        ],
     [
        "id":"3",
        "name":"クレーンゲーム無料",
        "area":"2F GameCenter",
        "imageURLString":"https://sc.epark.jp/magazine/wp-content/uploads/2018/02/7693609d6322915d9ae164c3c54c020d_s.jpg",
        "description":"有効期限：2019年12月10日"
        ],
     [
        "id":"4",
        "name":"コーヒー１杯無料",
        "area":"1F スターバックス",
        "imageURLString":"https://www.marunouchi.com/media/tenants/t1015_image_1.jpg",
        "description":"有効期限：2020年1月10日"
        ],
     [
        "id":"5",
        "name":"ファブリーズ 20%OFF",
        "area":"3F Tomod's",
        "imageURLString":"https://askul.c.yimg.jp/img/product/3L1/A545869_3L1.jpg",
        "description":"有効期限：2020年2月10日"
        ],
     [
        "id":"6",
        "name":"ヒーロー握手券",
        "area":"屋上 ワクワク広場",
        "imageURLString":"https://cdn.amebaowndme.com/madrid-prd/madrid-web/images/sites/23693/7e22cdb34e20033e375c435955b3ce53_377cc7a561df07a909cee0ca95754017.jpg",
        "description":"有効期限：2020年3月10日"
        ]]
