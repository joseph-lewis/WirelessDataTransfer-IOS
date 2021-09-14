//
//  RegisterDevice.swift
//  WirelessDataTransfer
//
//  Created by Joe Lewis on 2/9/21.
//

import Foundation
import UIKit

class RegisterDevice {

    struct Request : Codable {
        let Method : String = "RegisterDevice"
        let DeviceUID : String
        let AppVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let DeviceName: String = UIDevice.current.name
        let DeviceVersion: String = UIDevice.current.systemVersion
        let DeviceModel: String = UIDevice.current.model
        let DeviceOS: String = UIDevice.current.systemName
        let DeviceModelType: String = UIDevice.current.modelName
        
    }

    struct Response : Codable  {
        let Status: Int
        let Message: String
        let DeviceID: Int?
        let UI: String?
    }
    
    
}

extension UIDevice{
    var modelName: String{
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        
        let identifier = machineMirror.children.reduce(""){identifier, element in
            guard let value = element.value as? Int8, value != 0 else {return identifier}
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier

    }
    
}
