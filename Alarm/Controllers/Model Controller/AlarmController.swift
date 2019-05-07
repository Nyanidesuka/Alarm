//
//  AlarmController.swift
//  Alarm
//
//  Created by Haley Jones on 5/6/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//

import Foundation
import UserNotifications

protocol AlarmScheduler: class{
    func scheduleUserNotifications(forAlarm: Alarm)
    func cancelUserNotifications(forAlarm: Alarm)
    
}
extension AlarmScheduler{
    func scheduleUserNotifications(forAlarm: Alarm){
        //so the first thing is you have to define the content thats gonna show up in the notification
        let content = UNMutableNotificationContent()
        content.title = "Alarm!"
        content.body = "The alarm you set is going off."
        content.sound = UNNotificationSound.default
        //then you have to define what triggers it
        //which first needs date components
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: forAlarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: forAlarm.uuid, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil{
            print("Error: \(error?.localizedDescription)")
            } else {
                print("notification scheduled")
            }
        }
    }
    func cancelUserNotifications(forAlarm: Alarm){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [forAlarm.uuid])
    }
}

class AlarmController: AlarmScheduler{
    
    static let shared = AlarmController()
    
    var alarms: [Alarm] = []
    
    //MARK: CRUD
    func addAlarm(fireDate: Date, name: String, enabled: Bool) -> Alarm {
        let newAlarm = Alarm(name: name, fireDate: fireDate, enabled: enabled)
        AlarmController.shared.alarms.append(newAlarm)
        saveToPersistentStore()
        return newAlarm
        
    }
    
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool){
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
        saveToPersistentStore()
    }
    
    func deleteAlarm(alarm: Alarm){
        guard let targetIndex = AlarmController.shared.alarms.firstIndex(of: alarm) else {return}
        AlarmController.shared.alarms.remove(at: targetIndex)
        saveToPersistentStore()
    }
    
    func toggleEnabled(forAlarm: Alarm){
        forAlarm.enabled = !forAlarm.enabled
        if forAlarm.enabled{
            scheduleUserNotifications(forAlarm: forAlarm)
        } else {
            cancelUserNotifications(forAlarm: forAlarm)
        }
        saveToPersistentStore()
    }
    
    //MARK: Persistence
    func getURL() -> URL{
        //set filename up first of all.
        let filename = "savedAlarms.json"
        //get the paths array
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //grab the first path
        let path = paths[0]
        //append it with the filename
        let fullURL = path.appendingPathComponent(filename)
        return fullURL
    }
    
    func saveToPersistentStore(){
        //first thing's first we make an encoder
        let encoder = JSONEncoder()
        //now we try to make alarms into data
        do{
            let alarmsAsJSON = try encoder.encode(AlarmController.shared.alarms)
            let alarmsAsData = Data(alarmsAsJSON)
            //try to write it
            try alarmsAsData.write(to: getURL())
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    func loadFromPersistentStore(){
        //first we make a decoder
        let decoder = JSONDecoder()
        //now we get data from a file
        do{
            let alarmsAsData = try Data(contentsOf: getURL())
            let decodedAlarms = try decoder.decode([Alarm].self, from: alarmsAsData)
            AlarmController.shared.alarms = decodedAlarms
        } catch let error {
            print("Error: \(error)")
        }
    }
    
}
