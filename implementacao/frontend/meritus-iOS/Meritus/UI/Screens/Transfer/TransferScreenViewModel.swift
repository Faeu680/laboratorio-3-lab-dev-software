//
//  TransferScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 03/11/25.
//

import SwiftUI
import Combine
import Domain
import Session

@MainActor
final class TransferScreenViewModel: ObservableObject {
    private let makeTransferUseCase: MakeTransferUseCaseProtocol
    private let getStudentsOfInstitutionUseCase: GetStudentsOfInstitutionUseCaseProtocol
    
    let storedSession: StoredSession?
    
    @Published var isLoading: Bool = false
    @Published var students: [StudentModel]  = []
    @Published var selectedStudent: StudentModel? = nil
    @Published var transferAmount: String = ""
    @Published var showTransferModal: Bool = false
    @Published var transferResult: TransferScreenViewResultRoute?
    @Published var searchText: String = ""

    var filteredStudents: [StudentModel] {
        guard !searchText.isEmpty else { return students }
        
        return students.filter {
            $0.name.lowercased().contains(searchText.lowercased()) ||
            $0.email.lowercased().contains(searchText.lowercased())
        }
    }

    init(
        session: SessionProtocol,
        makeTransferUseCase: MakeTransferUseCaseProtocol,
        getStudentsOfInstitutionUseCase: GetStudentsOfInstitutionUseCaseProtocol
    ) {
        self.storedSession = session.unsafeGetActiveSession()
        self.makeTransferUseCase = makeTransferUseCase
        self.getStudentsOfInstitutionUseCase = getStudentsOfInstitutionUseCase
    }
    
    func onViewDidLoad() async {
        do {
            let students = try await getStudentsOfInstitutionUseCase.execute()
            self.students = students
        } catch { }
    }
    
    func didSelectStudent(_ student: StudentModel) {
        self.selectedStudent = student
        showTransferModal = true
    }
    
    func didTapTransferButton() async {
        guard let selectedStudent else { return }
        
        let model = MakeTransferModel(
            studentId: selectedStudent.id,
            amount: transferAmount,
            message: "cavalos da transferencia"
        )
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await makeTransferUseCase.execute(model)
            transferResult = .success
        } catch {
            transferResult = .error
        }
    }
    
    func dismissTransferModal() {
        showTransferModal = false
        transferResult = nil
    }
}
