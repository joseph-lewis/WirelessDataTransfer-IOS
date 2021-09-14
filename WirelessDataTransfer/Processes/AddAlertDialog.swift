//
//  AddAlertDialog.swift
//  WirelessDataTransfer
//
//  Created by Joe Lewis on 14/9/21.
//

import Foundation
import UIKit

class AddAlertDialog {
    var context: UIViewController
    
    init(context: UIViewController){
        self.context = context
    }

    
    func sendOKMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        context.present(alert, animated: true)
    }
    
    func sendOKMessageGoHome(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {[self]action in
            DispatchQueue.main.async {
                context.navigationController?.popToRootViewController(animated: true)
            }
        }))
        context.present(alert, animated: true)
    }
    
    
}
