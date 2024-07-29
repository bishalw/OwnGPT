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
    var hasUserOnboarded: Bool { get }
    func updateOnBoarded()
}
class RootViewModelImpl: RootViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    private var userDefaultsStore: UserDefaultsStore
    
    @Published  var hasUserOnboarded: Bool = false
    
    init(userDefaultsStore: UserDefaultsStore) {
        self.userDefaultsStore = userDefaultsStore
        self.hasUserOnboarded = userDefaultsStore.hasOnboarded
        self.setupObservers()
    }
   
    
    private func setupObservers() {
        userDefaultsStore.hasUserOnboardedPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                self?.hasUserOnboarded = newValue
            }
            .store(in: &cancellables)
    }

    func updateOnBoarded() {
        userDefaultsStore.hasOnboarded = true
    }
}
