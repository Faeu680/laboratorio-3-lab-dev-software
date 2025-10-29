//
//  UserRole.swift
//  Session
//
//  Created by Arthur Porto on 29/10/25.
//

public enum UserRole: String, Decodable, Sendable {
    case student = "STUDENT"
    case teacher = "TEACHER"
    case company =  "COMPANY"
}
