//
//  PersonalDocumentStatus.swift
//  ZuTapp
//
//  Created by Joe Lewis on 26/7/21.
//

import Foundation


class PersonalDocumentStatus : Codable {
    let SID : Int?
    let UID : Int?
    let DocumentId : Int?
    let Status : Int? //Constants.SITE_PERSONAL_DOCUMENT_STATUS_UNNKNOWN etc
 
    enum CodingKeys: String, CodingKey {
        case SID = "SID"
        case UID = "UID"
        case DocumentId = "DID"
        case Status = "S"
     }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        SID = try values.decodeIfPresent(Int.self, forKey: .SID)
        UID = try values.decodeIfPresent(Int.self, forKey: .UID)
        DocumentId = try values.decodeIfPresent(Int.self, forKey: .DocumentId)
        Status = try values.decodeIfPresent(Int.self, forKey: .Status)
     }
}
