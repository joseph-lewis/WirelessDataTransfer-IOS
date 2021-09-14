//
//  Document.swift
//  ZuTapp
//
//  Created by Joe Lewis on 26/7/21.
//

import Foundation

class Document : Codable {
    let DID : Int?
    let UID : Int?
    let Name : String?
//    let DocumentUrl : String?
    let DocumentName : String?
    let ExpiryDate : String?
    let IsSuspended : Bool
    let IsDeleted : Bool
    let DocumentTypeId : Int?
    let LastModifiedDate : String?
    let documentType : DocumentType?
    let DocumentStatus : PersonalDocumentStatus?
    
    enum CodingKeys: String, CodingKey {
        case DID = "DID"
        case UID = "UID"
        case Name = "N"
//        case DocumentUrl = "DocumentUrl"
        case DocumentName = "DN"
        case ExpiryDate = "ED"
        case IsSuspended = "IS"
        case IsDeleted = "ID"
        case DocumentTypeId = "DTI"
        case documentType = "DT"
        case DocumentStatus = "DS"
        case LastModifiedDate = "LMD"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        DID = try values.decodeIfPresent(Int.self, forKey: .DID)
        UID = try values.decodeIfPresent(Int.self, forKey: .UID)
        Name = try values.decodeIfPresent(String.self, forKey: .Name)
//        DocumentUrl = try values.decodeIfPresent(String.self, forKey: .DocumentUrl)
        DocumentName = try values.decodeIfPresent(String.self, forKey: .DocumentName)
        ExpiryDate = try values.decodeIfPresent(String.self, forKey: .ExpiryDate)
        
        IsSuspended = values.decodeBoolAndIntToBool(key: .IsSuspended)
//        IsSuspended = try values.decodeIfPresent(Bool.self, forKey: .IsSuspended)
        
        IsDeleted = values.decodeBoolAndIntToBool(key: .IsDeleted)
//        IsDeleted = try values.decodeIfPresent(Bool.self, forKey: .IsDeleted)
        
        DocumentTypeId = try values.decodeIfPresent(Int.self, forKey: .DocumentTypeId)
        documentType = try values.decodeIfPresent(DocumentType.self, forKey: .documentType)
        DocumentStatus = try values.decodeIfPresent(PersonalDocumentStatus.self, forKey: .DocumentStatus)
        LastModifiedDate = try values.decodeIfPresent(String.self, forKey: .LastModifiedDate)
    }

    func getExpireDate()->Date?{
        return ExpiryDate?.utcStringToDate() ?? nil
    }
    
}
