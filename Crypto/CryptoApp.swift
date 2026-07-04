//
//  CryptoApp.swift
//  Crypto
//
//  Created by hosam on 04/07/2026.
//

import SwiftUI

@main
struct CryptoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            NavigationStack{
                Home()
                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                    .toolbar(.hidden)
            }
        }
    }
}
