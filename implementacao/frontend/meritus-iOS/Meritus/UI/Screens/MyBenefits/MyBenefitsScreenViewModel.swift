//
//  MyBenefitsScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 28/11/25.
//

import Combine
import Domain

final class MyBenefitsScreenViewModel: ObservableObject {
    private let getMyBenefitsUseCase: GetMyBenefitsUseCaseProtocol
    
    @Published var myBenefits: [RedeemBenefitModel] = []
    
    init(getMyBenefitsUseCase: GetMyBenefitsUseCaseProtocol) {
        self.getMyBenefitsUseCase = getMyBenefitsUseCase
    }
    
    func onViewDidLoad() async {
        do {
            let myBenefits = try await getMyBenefitsUseCase.execute()
            self.myBenefits = myBenefits
        } catch { }
    }
}
