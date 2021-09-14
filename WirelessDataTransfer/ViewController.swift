//
//  ViewController.swift
//  WirelessDataTransfer
//
//  Created by Joe Lewis on 2/9/21.
//

import UIKit


class ViewController: UIViewController, UINavigationControllerDelegate {
    var pickerController: UIImagePickerController?
    var mDocument : Document? = nil
    var fileStream:String?
    var fileType: String?
    var preferences = Preferences()
    let manager = HttpAPI()
    var deviceID: Int?
    
    
    @IBAction func uploadFileTap(_ sender: Any) {
        selectDocument()
    }
    @IBOutlet weak var UIDTextView: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(preferences.getDeviceUID())
        //Check if device is new, if so register to server and save locally
        if preferences.getDeviceUniqueCode() == "" {
            runInitialSetup()
        }
        else{
            UIDTextView.text = preferences.getDeviceUniqueCode()
            deviceID = preferences.getDeviceServerID()
        }
    }


    func runInitialSetup(){
        var deviceUID: String = UIDevice.current.identifierForVendor!.uuidString
        preferences.setDeviceUID(value: deviceUID)
                
        var request = RegisterDevice.Request(DeviceUID: deviceUID)
        
        //Encode Struct to JSON String
        guard let encodedData = try? JSONEncoder().encode(request) else {
            print("Error encoding JSON")
            return}
        let jsonString = String(data: encodedData, encoding: .utf8)
        print("This is the JSON String to Send - " + jsonString!)
        
        //Send JSON String to server and Return Response JSON String
        let jsonResponse = manager.sendData(jsonString: jsonString!)
        print("This is the Return JSON String - " + jsonResponse)
        
        let jsonData = Data(jsonResponse.utf8)
        let response = try! JSONDecoder().decode(RegisterDevice.Response.self, from: jsonData)
 
        //Check if nil, if so ignore
        response.UI != nil ? preferences.setDeviceUniqueCode(value: response.UI!): print("UniqueIdentifier is nil - Ignoring")
        response.DeviceID != nil ? preferences.setDeviceServerID(value: response.DeviceID!): print("DeviceID is nil - Ignoring")
        

        
        UIDTextView.text = response.UI!
    
    }
    
    
    func fileUploaded() {
        if fileStream != nil {
            print("Document Uploaded! \(fileType)")
            
            sendFileToServer()
//            var testData = Data(base64Encoded: fileStream!, options: .ignoreUnknownCharacters)
//            var test = UIImage(data: testData!)
//            guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
//                return
//            }
//            do{
//                try testImg!.write(to: directory.appendingPathComponent("Test.jpeg")!)
//
//            }
//            catch{
//                print("Error - \(error)")
//            }
            
        }
    }
    
    func sendFileToServer(){
        var request = SendFileToDevice.Request(SenderDeviceID: deviceID!, ReceiverDeviceID: 0, FileType: fileType!, FileBase64: fileStream!)
        
        //Encode Struct to JSON String
        guard let encodedData = try? JSONEncoder().encode(request) else {
            print("Error encoding JSON")
            return}
        let jsonString = String(data: encodedData, encoding: .utf8)
        print("This is the JSON String to Send - " + jsonString!)
        
        //Send JSON String to server and Return Response JSON String
        let jsonResponse = manager.sendData(jsonString: jsonString!)
        print("This is the Return JSON String - " + jsonResponse)
        
        let jsonData = Data(jsonResponse.utf8)
        let response = try! JSONDecoder().decode(SendFileToDevice.Response.self, from: jsonData)
        AddAlertDialog(context: self).sendOKMessageGoHome(title: "File Upload", message: response.Message)

    }
    
}

