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
    private let biometryManager: BiometryManagerProtocol
    
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
        getStudentsOfInstitutionUseCase: GetStudentsOfInstitutionUseCaseProtocol,
        biometryManager: BiometryManagerProtocol
    ) {
        self.storedSession = session.unsafeGetActiveSession()
        self.makeTransferUseCase = makeTransferUseCase
        self.getStudentsOfInstitutionUseCase = getStudentsOfInstitutionUseCase
        self.biometryManager = biometryManager
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
        
        isLoading = true
        defer { isLoading = false }
        
        guard await evaluateBiometry() else { return }
        
        let model = MakeTransferModel(
            studentId: selectedStudent.id,
            amount: transferAmount,
            message: "cavalos da transferencia"
        )
        
        do {
            try await makeTransferUseCase.execute(model)
            transferResult = .success
        } catch {
            transferResult = .error
        }
    }
    
    func handleFeedbackAnimationFinished() {
        dismissTransferModal()
    }
    
    func dismissTransferModal() {
        showTransferModal = false
        transferResult = nil
    }
    
    private func evaluateBiometry() async -> Bool {
        do {
            try await biometryManager.authenticate(reason: "Utilizamos sua biometria para validar sua transação")
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            return true
        } catch {
            switch error {
            case .failed, .biometryNotEnrolled, .biometryNotAvailable:
                return true
            case .cancelled:
                return false
            }
        }
    }
}
