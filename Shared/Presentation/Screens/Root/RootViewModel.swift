//
//  RootViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 7/22/24.
//

import Foundation
import Bkit
import Combine

class RootViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    private let userDefaultsStore: UserDefaultsStore
    
    @Published  var hasOnboarded: Bool = false
    
    init(userDefaultsStore: UserDefaultsStore) {
        self.userDefaultsStore = userDefaultsStore
        self.setupObservers()
    }
    
    func setupObservers() {
        userDefaultsStore.$hasOnboarded.sink { value in
            self.hasOnboarded = value
        }
        .store(in: &cancellables)
    }
    
    func updateOnboarded() {
        userDefaultsStore.hasOnboarded = true
    }
}
