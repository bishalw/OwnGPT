//
//  MainViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 7/19/24.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let userDefaultsStore: UserDefaultsStore
    
    @Published private var hasOnboard: Bool = false
    
    init(userDefaultsStore: UserDefaultsStore) {
        self.userDefaultsStore = userDefaultsStore
        self.setupObservers()
    }
    
    func setupObservers() {
        self.userDefaultsStore.hasOnboardedDidChange.sink { value in
            self.hasOnboard = value
        }
        .store(in: &cancellables)
    }
}
