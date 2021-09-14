//
//  PersonalDocument.swift
//  ZuTapp
//
//  Created by Joe Lewis on 26/7/21.
//

import Foundation

class PersonalDocument : Codable {
    let SID : Int?
    let UID : Int?
    let DocumentTypeID : Int?

    enum CodingKeys: String, CodingKey {
        case SID = "SID"
        case UID = "UID"
        case DocumentTypeID = "DTID"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        SID = try values.decodeIfPresent(Int.self, forKey: .SID)
        UID = try values.decodeIfPresent(Int.self, forKey: .UID)
        DocumentTypeID = try values.decodeIfPresent(Int.self, forKey: .DocumentTypeID)
    }
    
    init(sid:Int, uid:Int, documentTypeID:Int) {
        SID = sid
        UID = uid
        DocumentTypeID = documentTypeID
    }
}
