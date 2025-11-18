//
//  BodyType.swift
//  Networking
//
//  Created by Arthur Porto on 13/11/25.
//

import Foundation

public enum BodyType {
    case json(Encodable)
    case data(Data)
    case none
}
