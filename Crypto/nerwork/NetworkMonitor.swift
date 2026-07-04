import Network
import Combine
import SwiftUI

import Network

class NetworkMonitor: ObservableObject {
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue.global(qos: .background)
    @Published var isConnected: Bool = false

    init() {
        monitor = NWPathMonitor()
        startMonitoring()
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.checkInternetConnectivity { hasInternet in
                        DispatchQueue.main.async {
                            self.isConnected = hasInternet

                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        
                        self.isConnected = false
                    }
                }
            }
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }

    private func checkInternetConnectivity(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://www.google.com") else {
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5.0
        request.httpMethod = "HEAD"

        URLSession.shared.dataTask(with: request) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
}


class NetworkHandler {
    static let shared = NetworkHandler()

    private init() {}

    func callAPI()  {
//        makeVisist()
//        makeOW() 
    }
}
