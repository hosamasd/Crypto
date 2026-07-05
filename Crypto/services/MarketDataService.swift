//
//  MarketDataService.swift
//  Crypto
//
//  Created by hosam on 04/07/2026.
//

import SwiftUI
import Combine

class MarketDataService {
    @Published var marketData:MarketDataModel?=nil
    var cancelllable = Set<AnyCancellable>()
    var marketSubscription:AnyCancellable?
    
    
    init() {
        getMarket()
    }
    
     func getMarket(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return  }
        
        marketSubscription =  NetworkManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion(completion:), receiveValue: {[weak self] coins in
                guard let self = self else { return  }
                self.marketData=coins.data
                self.marketSubscription?.cancel()
            })
    }
    
}
