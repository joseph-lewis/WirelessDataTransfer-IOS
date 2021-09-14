//
//  Preferences.swift
//  WirelessDataTransfer
//
//  Created by Joe Lewis on 2/9/21.
//

import Foundation
import UIKit

class Preferences{
    
//    static let instance:  Preferences = Preferences()
    let preferences = UserDefaults.standard

    func setDeviceUID(value: String){
        preferences.set(value, forKey: "deviceUID")
    }
    
    func getDeviceUID() -> String {
        return preferences.string(forKey: "deviceUID") ?? ""
        
    }
    
    func setDeviceUniqueCode(value: String){
        preferences.set(value, forKey: "deviceShareCode")
    }
    
    func getDeviceUniqueCode() -> String {
        return preferences.string(forKey: "deviceShareCode") ?? ""
    }
    
    func setDeviceServerID(value: Int){
        preferences.set(value, forKey: "deviceServerID")
    }
    
    func getDeviceServerID() -> Int? {
        return preferences.integer(forKey: "deviceServerID") ?? nil
    }
}
