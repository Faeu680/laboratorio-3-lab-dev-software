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
    private let getBalanceUseCase: GetBalanceUseCaseProtocol
    private let makeTransferUseCase: MakeTransferUseCaseProtocol
    private let getStudentsOfInstitutionUseCase: GetStudentsOfInstitutionUseCaseProtocol
    private let biometryManager: BiometryManagerProtocol
    
    let storedSession: StoredSession?
    var balance: String = ""
    
    @Published var isDisabled: Bool = true
    @Published var isLoading: Bool = false
    @Published var students: [StudentModel]  = []
    @Published var selectedStudent: StudentModel? = nil
    @Published var showTransferModal: Bool = false
    @Published var transferResult: TransferScreenViewResultRoute?
    @Published var searchText: String = ""
    @Published var description: String = ""
    @Published var transferAmount: String = "" {
        didSet {
            handleTransferAmountChange(transferAmount)
        }
    }

    var filteredStudents: [StudentModel] {
        guard !searchText.isEmpty else { return students }
        
        return students.filter {
            $0.name.lowercased().contains(searchText.lowercased()) ||
            $0.email.lowercased().contains(searchText.lowercased())
        }
    }
    
    var finalBalance: String {
        let finalBalance = (Int(balance) ?? 0) - (Int(transferAmount) ?? 0)
        return "\(finalBalance)"
    }

    init(
        session: SessionProtocol,
        getBalanceUseCase: GetBalanceUseCaseProtocol,
        makeTransferUseCase: MakeTransferUseCaseProtocol,
        getStudentsOfInstitutionUseCase: GetStudentsOfInstitutionUseCaseProtocol,
        biometryManager: BiometryManagerProtocol
    ) {
        self.storedSession = session.unsafeGetActiveSession()
        self.getBalanceUseCase = getBalanceUseCase
        self.makeTransferUseCase = makeTransferUseCase
        self.getStudentsOfInstitutionUseCase = getStudentsOfInstitutionUseCase
        self.biometryManager = biometryManager
    }
    
    func onViewDidLoad() async {
        await getStudents()
        await getBalance()
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
    
    func dismissTransferModal() {
        guard !isLoading else { return }
        
        showTransferModal = false
        clearInputs()
    }
    
    private func getStudents() async {
        do {
            let students = try await getStudentsOfInstitutionUseCase.execute()
            self.students = students
        } catch { }
    }
    
    private func getBalance() async {
        do {
            let balance = try await getBalanceUseCase.execute()
            self.balance = balance
        } catch { }
    }
    
    private func clearInputs() {
        isDisabled = true
        isLoading = false
        transferAmount = ""
        selectedStudent = nil
        transferResult = nil
    }
    
    private func handleTransferAmountChange(_ amount: String) {
        let intAmount = Int(amount) ?? 0
        let intBalance = Int(balance) ?? 067
        
        guard intAmount > 0 else {
            self.isDisabled = true
            return
        }
        
        guard intBalance > intAmount else {
            self.isDisabled = true
            return
        }
        
        self.isDisabled = false
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
