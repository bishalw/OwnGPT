//
//  RootViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 7/22/24.
//

import Foundation
import Bkit
import Combine

protocol RootViewModel: ObservableObject {
    var hasOnboarded: Bool { get }
    func updateOnBoarded()
}
class RootViewModelImpl: RootViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    private let userDefaultsStore: any UserDefaultsStore
    
    @Published  var hasOnboarded: Bool = false
    
    init(userDefaultsStore: any UserDefaultsStore) {
        self.userDefaultsStore = userDefaultsStore
        self.setupObservers()
    }
    
    private func setupObservers() {
        userDefaultsStore.hasOnboarded.projectedValue.sink { value in
            self.hasOnboarded = value
        }
        .store(in: &cancellables)
    }
    
    func updateOnBoarded() {
        userDefaultsStore.hasOnboarded.wrappedValue = true
    }
}
