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
    @Published var isLoading:Bool=false
    @Published var sortOption:SortOptions = .holdings
    @Published var selectedCoin:CoinModel=CoinModel(id: "", symbol: "", name: "", image: "", currentPrice: 0.0, marketCap: 0, marketCapRank: 0, fullyDilutedValuation: 0, totalVolume: 0, high24H: 0, low24H: 0, priceChange24H: 0, priceChangePercentage24H: 0, marketCapChange24H: 0, marketCapChangePercentage24H: 0, circulatingSupply: 0, totalSupply: 0, maxSupply: 0, ath: 0, athChangePercentage: 0, athDate: "", atl: 0, atlChangePercentage: 0, atlDate: "", lastUpdated: "", sparklineIn7D: nil, priceChangePercentage24HInCurrency: 0, currentHoldings: 0   )


    @Published  var statistics:[StatisticModel] = [ ]
    
    private var cancelllable = Set<AnyCancellable>()
    private let coinDataService=CoinDataServices()
    private let marketDataService=MarketDataService()
    private let portfolioDataService=PortfolioDataService()

    enum SortOptions {
    case price,priceReversed,rank,rankReversed,holdings,holdingsReversed
    }
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
            .combineLatest(coinDataService.$allCoins,$sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map (filterAndSortCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self=self else{return}
                self.allCoins=returnedCoins
            }
            .store(in: &cancelllable)
        
        $allCoins
            .combineLatest(portfolioDataService.$savedEntites)
            .map (mapAllCoinToPortfolioCoins)
            .sink {[weak self] (returnedCoins) in
                guard let self=self else{return}
                self.portfolioCoins=sortPortfolioIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancelllable)
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(marketStatsData)
            .sink { [weak self] (returnedStats) in
                guard let self=self else{return}
                self.statistics=returnedStats
                self.isLoading=false
            }
            .store(in: &cancelllable)
        
      
        
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double)  {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData()  {
        isLoading=true
        coinDataService.getCoins()
        marketDataService.getMarket()
        HapticManager.notification(type: .success)
    }
    
    private func filterAndSortCoins(text:String,coins:[CoinModel],sortOption:SortOptions) ->[CoinModel]{
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sortOption: sortOption, coins: &updatedCoins)
        return updatedCoins
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
    
    func mapAllCoinToPortfolioCoins(allCoins:[CoinModel],portfolioEntites:[PortfolioEntity]) -> [CoinModel] {
        allCoins
            .compactMap { (coin)->CoinModel? in
               guard let entity = portfolioEntites.first(where:{$0.coinID==coin.id}) else{
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
   private func sortCoins(sortOption:SortOptions,coins:inout [CoinModel]) {
        switch sortOption {
        case .rank,.holdings:
            coins.sort(by: {$0.rank < $1.rank})
        case .rankReversed,.holdingsReversed:
            coins.sort(by: {$0.rank > $1.rank})
        case .price:
            coins.sort(by: {$0.currentPrice > $1.currentPrice})
        case .priceReversed:
            coins.sort(by: {$0.currentPrice < $1.currentPrice})
        
        }
    }
    
    private func sortPortfolioIfNeeded(coins: [CoinModel]) ->[CoinModel] {
        switch sortOption {
        case .holdings:
           return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReversed:
           return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
        
    }
    
    private func marketStatsData(marketDtatModel:MarketDataModel?,porfolioCoins:[CoinModel]) ->[StatisticModel]{
        var stats:[StatisticModel] = []
        guard let data=marketDtatModel else{return stats}
        
        let marketCap = StatisticModel(title: "Market Cop", value: data.marketCap)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = porfolioCoins.map{$0.currentHoldingsValue}.reduce(0, +)
        let previusValue = portfolioCoins.map { (coin) -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
            let previousValue = currentValue / (1 + percentChange)
            return previousValue
          }
            .reduce(0, +)
        let percentageChange = ((portfolioValue - previusValue) / previusValue) * 100
        
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [marketCap,volume,btcDominance,portfolio])
        return stats
        
        
    }
}
