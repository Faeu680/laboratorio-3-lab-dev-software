//
//  GetStudentsOfInstitutionUseCase.swift
//  Domain
//
//  Created by Arthur Porto on 21/11/25.
//

final class GetStudentsOfInstitutionUseCase: GetStudentsOfInstitutionUseCaseProtocol {
    private let service: StudentsServiceProtocol
    
    init(service: StudentsServiceProtocol) {
        self.service = service
    }
    
    func execute() async throws(GetStudentsOfInstitutionUseCaseError) -> [StudentModel] {
        do {
            let students = try await service.getStudentsOfInstitution()
            return students
        } catch {
            throw .todo
        }
    }
}
