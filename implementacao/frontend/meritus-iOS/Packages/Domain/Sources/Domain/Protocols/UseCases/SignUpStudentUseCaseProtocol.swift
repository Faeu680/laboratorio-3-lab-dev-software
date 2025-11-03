//
//  SignUpStudentUseCaseProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 02/11/25.
//

public protocol SignUpStudentUseCaseProtocol: Sendable {
    func execute(student: RegisterStudentModel) async throws(SignUpStudentUseCaseError)
}
