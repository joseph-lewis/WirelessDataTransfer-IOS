//
//  SendFile.swift
//  WirelessDataTransfer
//
//  Created by Joe Lewis on 13/9/21.
//

import Foundation
class SendFileToDevice {

    struct Request : Codable {
        let Method : String = "SendFileToDevice"
        let SenderDeviceID : Int
        let ReceiverDeviceID : Int
        let FileType: String
        let FileBase64: String
    }

    struct Response : Codable  {
        let Status: Int
        let Message: String
    }
    
    
}
