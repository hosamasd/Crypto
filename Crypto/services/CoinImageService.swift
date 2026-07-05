//
//  CoinImageService.swift
//  Crypto
//
//  Created by hosam on 04/07/2026.
//

import Foundation
import Combine
import UIKit

class CoinImageService {
    @Published var image:UIImage?=nil
    var imgSubscription:AnyCancellable?
    private let coin:CoinModel
    
    private let fileManager=LocalFileManager.instance
    private let folderName="coin_images"

    private func getImages(){
        if let savedImage=fileManager.getImage(imageName: coin.id, folderName: folderName) {
            image=savedImage
            print("Reterived image from file manager")
        }else{
            downloadCoinImage()
            print("download image first")
        }
    }
    
    init(coin:CoinModel) {
        self.coin=coin
        getImages()
    }
    
    private func downloadCoinImage(){
        guard let url = URL(string:coin.image) else{return}
        
        imgSubscription =  NetworkManager.download(url: url)
            .tryMap({ (data) ->UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion(completion:), receiveValue: {[weak self] img in
                guard let self = self,let downloadedImg=img else { return  }
                self.image=img
                self.imgSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImg, imageName: coin.id, folderName: self.folderName)
            })
    }
}
