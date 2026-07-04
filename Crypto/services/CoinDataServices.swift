//
//  CoinDataServices.swift
//  Crypto
//
//  Created by hosam on 04/07/2026.
//

import Foundation
import SwiftUI
import Combine

class CoinDataServices {
    @Published var allCoins:[CoinModel]=[]
    var cancelllable = Set<AnyCancellable>()
    var coinSubscription:AnyCancellable?
    
    
    init() {
        getCoins()
    }
    
    private func getCoins(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return  }
        
        coinSubscription =  NetworkManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion(completion:), receiveValue: {[weak self] coins in
                guard let self = self else { return  }
                self.allCoins=coins
                self.coinSubscription?.cancel()
            })
         
//            .store(in: &cancelllable)

        
    }
    
}
