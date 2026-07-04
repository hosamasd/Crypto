//
//  networkManager.swift
//  Crypto
//
//  Created by hosam on 04/07/2026.
//

import Foundation
import Combine

class NetworkManager {
    
    enum NetworkingError:LocalizedError {
        case baseUrlResponse(url:URL)
        case unknown
        
        var errorDescription: String?{
            switch self {
            case .baseUrlResponse(url:let url):
                return "bad response from url \(url)"
            case .unknown:
                return "unknown error happened!"
           
            }
        }
    }
    
    static func download(url:URL) ->AnyPublisher<Data,Error>{
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({try handleURLResponse(output: $0,url: url)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output:URLSession.DataTaskPublisher.Output,url:URL) throws -> Data{
        guard let response=output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else{
            throw NetworkingError.baseUrlResponse(url: url)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>){
        switch completion{
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
