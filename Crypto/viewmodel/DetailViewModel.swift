//
//  DetailViewModel.swift
//  Crypto
//
//  Created by hosam on 05/07/2026.
//

import SwiftUI
import Combine

class DetailViewModel: ObservableObject {
    @Published var overviewStatistic:[StatisticModel]=[]
    @Published var additionalStatistic:[StatisticModel]=[]

    private let coinDetailService:CoinDetailService
    var cancellable = Set<AnyCancellable>()
    @Published var coin:CoinModel
    
    init(coin:CoinModel) {
        self.coin=coin
        self.coinDetailService=CoinDetailService(coin: coin)
        self.addSubscribers()
    }
    
   private func addSubscribers()  {
       coinDetailService.$coinDetail
           .combineLatest($coin)
           .map({(coinDetailModel,coinModel) -> (overview: [StatisticModel],additional:[StatisticModel]) in
               
               let price = coinModel.currentPrice.asCurrencyWith6Decimals()
               let pricePercentageChange = coinModel.priceChangePercentage24H
               let priceStat = StatisticModel(title: "current price", value: price, percentageChange: pricePercentageChange)
               
               let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
               let marketCapPercentChange = coinModel.marketCapRank
               let marketCapStat = StatisticModel(title: "Market Captalization", value: marketCap, percentageChange: marketCapPercentChange)
               
               let rank = "\(coinModel.rank)"
               let rankStat = StatisticModel(title: "Rank", value: rank)
               
               let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
               let volumeStat = StatisticModel(title: "Volume", value: volume)
              
               
               let overviewArray:[StatisticModel] = [
                priceStat,marketCapStat,rankStat,volumeStat
               ]

               let high = (coinModel.high24H?.asCurrencyWith6Decimals()) ?? "n/a"
               let highStat = StatisticModel(title: "24h High", value: high)
               
               let low = (coinModel.low24H?.asCurrencyWith6Decimals()) ?? "n/a"
               let lowStat = StatisticModel(title: "24h Low", value: low)
               
               let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
               let pricePercentageChange2 = coinModel.priceChangePercentage24H
               let priceChangeStat = StatisticModel(title: "24h Price change", value: priceChange, percentageChange: pricePercentageChange2)
               
               let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
               let marketCapChangePercent2 = coinModel.marketCapChange24H
               let marketCapChangeStat =  StatisticModel(title: "24h Market cap change", value: marketCapChange, percentageChange: marketCapChangePercent2)

               let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
               let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
               let blockStat = StatisticModel(title: "Block time", value: blockTimeString)
               
               let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
               let hashingStat = StatisticModel(title: "Hashing Algorthim", value: hashing)
               
               let additionalArray:[StatisticModel] = [
                highStat,lowStat,priceChangeStat,marketCapChangeStat,blockStat,hashingStat
               ]
               
               return (overviewArray, additionalArray)
           })
           .sink {[weak self] (returnedVale) in
               guard let self=self else{return}
               self.overviewStatistic=returnedVale.overview
               self.additionalStatistic=returnedVale.additional
           }
           .store(in: &cancellable)
    }
}
