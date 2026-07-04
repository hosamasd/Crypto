//
//  HomeViewModel.swift
//  Crypto
//
//  Created by hosam on 04/07/2026.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var allCoins:[CoinModel]=[]
    @Published var portfolioCoins:[CoinModel]=[]
    private var cancelllable = Set<AnyCancellable>()
    private let dataService=CoinDataServices()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers()  {
        dataService.$allCoins
            .sink { returnedVal in
                self.allCoins=returnedVal
            }
            .store(in: &cancelllable)
    }
}
