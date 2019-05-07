//
//  Alarm.swift
//  Alarm
//
//  Created by Haley Jones on 5/6/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//

import Foundation

class Alarm: Codable{
    
    var name: String
    var fireDate: Date
    var enabled: Bool
    var uuid: String
    var fireTimeAsString: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: fireDate)
    }
    
    init(name: String, fireDate: Date, enabled: Bool){
        self.name = name
        self.fireDate = fireDate
        self.enabled = enabled
        self.uuid = UUID().uuidString
    }
}

extension Alarm: Equatable{
    static func ==(lhs: Alarm, rhs: Alarm) -> Bool{
        return lhs.name == rhs.name &&
        lhs.fireDate == rhs.fireDate &&
        lhs.enabled == rhs.enabled &&
        lhs.uuid == rhs.uuid
    }
}
