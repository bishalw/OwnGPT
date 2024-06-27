//
//  SideBarViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 6/24/24.
//

import Foundation
import Combine

class SideBarViewModel: ObservableObject {
    
    var mainViewSharedState: MainViewSharedState
    
    @Published var isSelected: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init(mainViewSharedState: MainViewSharedState) {
        self.mainViewSharedState = mainViewSharedState
    }
    
    func setupBindings() {
        mainViewSharedState.$isSelected
            .sink { [weak self] newValue in
                self?.isSelected = newValue
            }
            .store(in: &cancellables)
    }
    
}
