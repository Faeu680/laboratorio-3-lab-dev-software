//
//  GetStudentsOfInstitutionUseCaseProtocol.swift
//  Domain
//
//  Created by Arthur Porto on 21/11/25.
//

public protocol GetStudentsOfInstitutionUseCaseProtocol: Sendable {
    func execute() async throws(GetStudentsOfInstitutionUseCaseError) -> [StudentModel]
}
