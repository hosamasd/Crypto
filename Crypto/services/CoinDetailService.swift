//
//  CoinDetailService.swift
//  Crypto
//
//  Created by hosam on 05/07/2026.
//

import SwiftUI
import Combine

class CoinDetailService {
    @Published var coinDetail:CoinDetailModel?=nil
    var cancelllable = Set<AnyCancellable>()
    var coinDetailSubscription:AnyCancellable?
    let coin:CoinModel
    
    
    init(coin:CoinModel) {
        self.coin=coin
        getCoinDetail()
    }
    
     func getCoinDetail(){
         guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return  }
        
         coinDetailSubscription =  NetworkManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion(completion:), receiveValue: {[weak self] coins in
                guard let self = self else { return  }
                self.coinDetail=coins
                self.coinDetailSubscription?.cancel()
            })
    }
    
}
