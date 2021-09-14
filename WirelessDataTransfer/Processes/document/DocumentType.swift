//
//  DocumentType.swift
//  ZuTapp
//
//  Created by Joe Lewis on 26/7/21.
//

import Foundation

class DocumentType : Codable {
    let ID : Int?
    let Name : String?
    let Locale : String?
    let IsDeleted : Bool
    let SID : Int?

    enum CodingKeys: String, CodingKey {
        case ID = "ID"
        case Name = "N"
        case Locale = "L"
        case IsDeleted = "DEL"
        case SID = "SID"

    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ID = try values.decodeIfPresent(Int.self, forKey: .ID)
        Name = try values.decodeIfPresent(String.self, forKey: .Name)
        Locale = try values.decodeIfPresent(String.self, forKey: .Locale)
        
        IsDeleted = values.decodeBoolAndIntToBool(key: .IsDeleted)
//        IsDeleted = try values.decodeIfPresent(Bool.self, forKey: .IsDeleted)
        
        SID = try values.decodeIfPresent(Int.self, forKey: .SID)
    }
    
    init(id:Int, name:String, locale:String, isDeleted:Bool, sid:Int?) {
        ID = id
        Name = name
        Locale = locale
        IsDeleted = isDeleted
        SID = sid ?? -1 //-1 not 0. because 0 is for public document type
    }

}

