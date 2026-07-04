//
//  CoinImageScene.swift
//  Crypto
//
//  Created by hosam on 04/07/2026.
//

import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    @Published var image:UIImage?=nil
    @Published var isLoading:Bool=false
    
    private let coin:CoinModel
    private let dataService:CoinImageService
    private var cancelllable = Set<AnyCancellable>()

    init(coin:CoinModel) {
        self.coin=coin
        self.dataService=CoinImageService(coin: coin)
        addSubsscriber()
        self.isLoading=true
    }
    
    private func addSubsscriber(){
        
        dataService.$image
            .sink {  [weak self] (_) in
                guard let self=self else{return}
                self.isLoading=false
            } receiveValue: { [weak self] image in
                guard let self=self else{return}
                self.image=image
            }
            .store(in: &cancelllable)

    }
}

struct CoinImageScene: View {
    @StateObject var vm:CoinImageViewModel
    
    init(coin:CoinModel) {
        _vm=StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    var body: some View {
        ZStack{
            if let image = vm.image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                
            }else if vm.isLoading{
                ProgressView()
            }else{
                Image(systemName: "questionmark")
                    .foregroundStyle(Color.theme.secondaryText)
            }
        }
    }
}

struct CoinImageScenePreview:PreviewProvider {
    static var previews: some View{
        CoinImageScene(coin: dev.coin)
    }
}
