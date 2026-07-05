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
    @Published var supportedVSCurrencies:[String]=[]
    var cancelllable = Set<AnyCancellable>()
    var coinSubscription:AnyCancellable?
    private var currenciesSubscription: AnyCancellable?
    
    init() {
        getCoins()
        getSupportedVSCurrencies()
    }
    
    func getSupportedVSCurrencies()  {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/simple/supported_vs_currencies") else { return  }
        
        currenciesSubscription =  NetworkManager.download(url: url)
            .decode(type: SupportedVSCurrencies.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion(completion:), receiveValue: {[weak self] currencies in
                guard let self = self else { return  }
                self.supportedVSCurrencies=currencies
                self.currenciesSubscription?.cancel()
            })
    }
    
    func getCoins(selectedCurrency:String="usd"){
//         let locale = Locale.current
//                    let currencyCode = locale.currency?.identifier ?? "USD"
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=\(selectedCurrency)&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return  }
        
        coinSubscription =  NetworkManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion(completion:), receiveValue: {[weak self] coins in
                guard let self = self else { return  }
                self.allCoins=coins
                self.coinSubscription?.cancel()
            })
    }
    
}
