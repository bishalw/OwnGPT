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
    private let userDefaultsStore: UserDefaultsStore
    
    @Published  var hasOnboarded: Bool = false
    
    init(userDefaultsStore: UserDefaultsStore) {
        self.userDefaultsStore = userDefaultsStore
        self.setupObservers()
    }
    init(
        userDefaultsStore:  UserDefaultsStore,
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    ) {
        self.userDefaultsStore = userDefaultsStore
        self.cancellables = cancellables
        
    }
    
    private func setupObservers() {
 
    }
    
    func updateOnBoarded() {

    }
}
