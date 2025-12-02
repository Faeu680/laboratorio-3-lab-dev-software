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
import Commons

@MainActor
final class TransferScreenViewModel: ObservableObject {
    
    // MARK: - Private Properties
    
    private let getBalanceUseCase: GetBalanceUseCaseProtocol
    private let makeTransferUseCase: MakeTransferUseCaseProtocol
    private let getStudentsOfInstitutionUseCase: GetStudentsOfInstitutionUseCaseProtocol
    private let biometryManager: BiometryManagerProtocol
    private let soundManager = SoundManager.shared
    
    let storedSession: StoredSession?
    private(set) var balance: String = ""
    private(set) var selectedStudent: StudentModel? = nil
    
    // MARK: - Published Properties

    @Published var isLoading: Bool = false
    @Published var students: [StudentModel] = []
    @Published var showTransferModal: Bool = false
    @Published var transferResult: TransferScreenViewResultRoute?
    @Published var searchText: String = ""
    @Published var description: String = "" {
        didSet {
            if !description.isEmpty {
                descriptionFieldTouched = true
            }
            validateTransferButton()
        }
    }
    @Published var transferAmount: String = "" {
        didSet {
            validateTransferButton()
        }
    }
    @Published var isTransferButtonEnabled: Bool = false
    @Published var showDescriptionError: Bool = false
    @Published var descriptionFieldTouched: Bool = false

    // MARK: - Computed Properties

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
    
    // MARK: - Init

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
    
    // MARK: - Public Methods
    
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

        descriptionFieldTouched = true
        validateTransferButton()

        guard isTransferButtonEnabled else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        guard await evaluateBiometry() else { return }
        
        let model = MakeTransferModel(
            studentId: selectedStudent.id,
            amount: transferAmount,
            message: description
        )
        
        do {
            try await makeTransferUseCase.execute(model)
            transferResult = .success
            
            soundManager.play(
                "apple_pay_sound",
                ext: "mp3",
                bundle: .main
            )
        } catch {
            transferResult = .error
        }
    }
    
    func dismissTransferModal() {
        guard !isLoading else { return }

        showTransferModal = false
        clearInputs()
    }

    func markDescriptionFieldAsTouched() {
        descriptionFieldTouched = true
        validateTransferButton()
    }
    
    // MARK: - Private Methods
    
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
        isTransferButtonEnabled = false
        isLoading = false
        transferAmount = ""
        selectedStudent = nil
        transferResult = nil
        description = ""
        descriptionFieldTouched = false
        showDescriptionError = false
    }
    
    private func validateTransferButton() {
        let isDescriptionValid = !description.isEmpty
        let isAmountValid = isValidTransferAmount()

        showDescriptionError = descriptionFieldTouched && description.isEmpty
        isTransferButtonEnabled = isDescriptionValid && isAmountValid
    }

    private func isValidTransferAmount() -> Bool {
        guard let amount = Int(transferAmount), amount > 0 else {
            return false
        }

        guard let userBalance = Int(balance) else {
            return false
        }

        return amount <= userBalance
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
