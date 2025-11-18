//
//  ContentType.swift
//  Networking
//
//  Created by Arthur Porto on 13/11/25.
//

public enum ContentType {
    public enum ImageType: String {
        case png = "image/png"
        case jpeg = "image/jpeg"
    }
    
    case json
    case image(ImageType)
    
    var rawValue: String {
        switch self {
        case .json:
            return "application/json"
        case .image(let type):
            return type.rawValue
        }
    }
}
