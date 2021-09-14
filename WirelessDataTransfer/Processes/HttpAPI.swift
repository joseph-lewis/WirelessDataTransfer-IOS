//
//  HttpAPI.swift
//  WirelessDataTransfer
//
//  Created by Joe Lewis on 2/9/21.
//

import Foundation

class HttpAPI {
    
    func sendData(jsonString : String ) -> String {
        //Make connection to server
        var jsonResponse : String = ""
        var httpRequestSent = false
        let url = URL(string: "http://192.168.86.72:63352/process")!
        var request = URLRequest(url: url)
        request.setValue("api/wdt", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = try! Data(jsonString.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            //If error print error
            if let error = error {
                        print(error)
                    }
            
            
            //Get response code
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                print("response code = \(httpResponse.statusCode)")
                //Get response JSON string, update global variable to retrieve later
                let responseString = String(data: data!, encoding: String.Encoding.utf8)
                jsonResponse = responseString!
                httpRequestSent = true
            }
            
        }
        task.resume()
        
        //Once Http Request has received response, return it as JSON String
        while(httpRequestSent == false){sleep(1)}
        return jsonResponse
    }
    
    
    
}



