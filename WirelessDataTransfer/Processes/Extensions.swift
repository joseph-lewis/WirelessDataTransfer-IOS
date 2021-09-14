//
//  Extensions.swift
//  WirelessDataTransfer
//
//  Created by Joe Lewis on 5/9/21.
//

import Foundation
import UIKit
import AVFoundation
import MobileCoreServices
import WebKit

extension ViewController : UIImagePickerControllerDelegate, UIDocumentPickerDelegate{
    
    func selectDocument(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .denied:
                print("Denied, request permission from settings")
                presentCameraSettings()
            case .restricted:
                print("Restricted, device owner must approve")
            case .authorized:
                print("Authorized, proceed")
                
                DispatchQueue.main.async {
                    self.launchCameraOptions()
                }

            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { success in
                    if success {
                        DispatchQueue.main.async {
                            self.launchCameraOptions()
                        }
                    } else {
                        print("Permission denied")
                    }
                }
        }
            
    }
    
    
    func launchCameraOptions(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
         
        alertController.addAction(UIAlertAction(title: "Pick Document", style: .default) { _ in
            let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeSpreadsheet, kUTTypePresentation, kUTTypeJPEG, kUTTypeJPEG2000, kUTTypePNG, kUTTypeGIF, "com.microsoft.word.doc" as CFString, "org.openxmlformats.wordprocessingml.document" as CFString]
            let importMenu = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)

            if #available(iOS 11.0, *) {
                importMenu.allowsMultipleSelection = false
            }
            
            importMenu.delegate = self
            importMenu.modalPresentationStyle = .formSheet

            self.present(importMenu, animated: true)
        })
        
        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
//        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
//            alertController.addAction(action)
//        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if let popoverController = alertController.popoverPresentationController {
          popoverController.sourceView = self.view
          popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
          popoverController.permittedArrowDirections = []
        }

        self.present(alertController, animated: true)
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            let imgController = UIImagePickerController()
            
            imgController.sourceType = type
            imgController.delegate = self
            imgController.allowsEditing = false
            self.present(imgController, animated: true)
        }
    }


func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let originalImage: UIImage = info[.originalImage] as! UIImage
//    let imageData:Data = originalImage.pngData()!
//    var fileExt: String = "jpeg"
    
//    print("Test - \(imageData.count)")
    var fileExt: String?

    //gives URL of media picked by user
    if let mediaURL = info[.imageURL] as? NSURL {
        let imageData:NSData = NSData.init(contentsOf: mediaURL as URL)!
        fileStream = imageData.base64EncodedString(options: .lineLength64Characters)
//        print("Base64 - \(fileStream)")
        fileExt = (mediaURL.absoluteString)!.fileExtension().lowercased()
        print("Media - \(mediaURL)")
        print("--file extension=" + fileExt!)
        fileUploaded()
    }
    else{
        let imageData:NSData = originalImage.pngData()! as NSData
        var fileStream = imageData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
//        print("Base64 - \(fileStream)")

        fileExt = "jpeg"
        print("Image taken on Camera!")
        fileUploaded()

    }
//    fileStream = imageData.base64EncodedString(options: .lineLength64Characters)
//    print(fileStream?.count)
//    fileUploaded()
    
    fileType = fileExt
    picker.dismiss(animated: true)

}
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Image cancelled")

    }
    

func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    print("documentPicker result size=" + urls.count.description)
    print(urls)
    if(urls.count > 0){
        let filePath = urls[0].absoluteString
        let fileURL : URL! = URL(string: filePath)

        
        print("This is the document - \(filePath)")
        
        let fileData = try! Data.init(contentsOf: fileURL)
        fileStream = fileData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        let fileExt = filePath.fileExtension().lowercased()
        print("--file extension=" + fileExt)
        fileType = fileExt
        print("Base64 - \(fileStream ?? "FileStream nil")")
        fileUploaded()
    }
    
}

    
func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    controller.dismiss(animated: true, completion: nil)

}
    
    
    func presentCameraSettings() {
        let alertController = UIAlertController(title: "Sorry",
                                                message: "error_camera_permission",
                                      preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })

        present(alertController, animated: true)
    }
    
    
    
}


extension String {
    func fileExtension() -> String {
        return NSURL(fileURLWithPath: self).pathExtension ?? ""
    }
    
    func localized()->String{
        NSLocalizedString(self, comment: "")
    }
    
    /////////////////////////////date string
    func localStringToDate(dateString:String, dateFormat:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.current

        return dateFormatter.date(from: dateString)
    }
     
    func utcStringToDate()->Date?{
        if let ex1 = utcStringToDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS"){
            return ex1
        }
        if let ex2 = utcStringToDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss"){
            return ex2
        }
        return nil
    }
    
    func utcStringToDate(dateFormat:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        return dateFormatter.date(from: self)
    }
    /////////////////////////////
}
