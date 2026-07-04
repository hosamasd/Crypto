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
    @Published var searchTxt:String=""

    @Published  var statistics:[StatisticModel] = [ ]
    
    private var cancelllable = Set<AnyCancellable>()
    private let coinDataService=CoinDataServices()
    private let marketDataService=MarketDataService()

    init() {
        addSubscribers()
    }
    
    func addSubscribers()  {
        //        dataService.$allCoins
        //            .sink { returnedVal in
        //                self.allCoins=returnedVal
        //            }
        //            .store(in: &cancelllable)
        
        $searchTxt
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map (filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins=returnedCoins
            }
            .store(in: &cancelllable)
        
        marketDataService.$marketData
            .map(marketStatsData)
            .sink { [weak self] (returnedStats) in
                self?.statistics=returnedStats
            }
            .store(in: &cancelllable)
    }
    
    private func filterCoins(text:String,coins:[CoinModel]) ->[CoinModel]{
        guard !text.isEmpty else{
            return coins
        }
        let lowerCaseText = text.lowercased()
        return coins.filter { coin in
            return coin.name.lowercased().contains(lowerCaseText)  || coin.symbol.lowercased().contains(lowerCaseText) || coin.id.lowercased().contains(lowerCaseText)
        }
    }
    
    private func marketStatsData(marketDtatModel:MarketDataModel?) ->[StatisticModel]{
        var stats:[StatisticModel] = []
        guard let data=marketDtatModel else{return stats}
        
        let marketCap = StatisticModel(title: "Market Cop", value: data.marketCap)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio Value", value: "$0:00", percentageChange: 0)
        
        stats.append(contentsOf: [marketCap,volume,btcDominance,portfolio])
        return stats
        
        
    }
}
