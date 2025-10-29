//
//  HomeScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 29/10/25.
//

import SwiftUI

struct HomeScreenView: View {
    
    @StateObject private var viewModel: HomeScreenViewModel
    
    init(viewModel: HomeScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text("Home Screen")
    }
}
