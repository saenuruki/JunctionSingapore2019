//
//  ARObject.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/27.
//  Copyright © 2019 塗木冴. All rights reserved.
//

import Foundation
import ObjectMapper
import FirebaseDatabase

class ARObject {
    var anchorID: String = ""
    var cloudAnchorID: String = ""
    var eventID: String = ""
    
    // TODO: - Firebaseとの疎通ができるようになったら消す
    init() {
        self.anchorID = "1"
        self.cloudAnchorID = "2"
        self.eventID = "リストランテ カッパス"
    }
    
    init?(dictionary: [String: Any]) {
        self.cloudAnchorID = dictionary["cloud_anchor_id"] as? String ?? ""
        self.eventID =  dictionary["event_id"] as? String ?? ""
    }
}
