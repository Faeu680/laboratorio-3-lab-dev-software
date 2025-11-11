//
//  NewBenefitScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 10/11/25.
//

import Combine

final class NewBenefitScreenViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var cost: String = ""
    
    @Published var isCameraPresented = false
    
    func didTapCreateBenefit() async {
//        let model = CreateBenefitModel(
//            name: name,
//            description: description,
//            photo: "",
//            cost: 10.0
//        )
//        
//        try? await createBenefitUseCase.execute(model)
    }
}
