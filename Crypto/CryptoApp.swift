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
    
    init() {
//            UINavigationBar.appearance().tintColor = Color.theme.accent
            UINavigationBar.appearance().barTintColor = UIColor(Color.theme.background)
            UINavigationBar.appearance().standardAppearance.backgroundColor = UIColor(Color.theme.background)
            UINavigationBar.appearance().compactAppearance?.backgroundColor = UIColor(Color.theme.background)
            UINavigationBar.appearance().scrollEdgeAppearance?.backgroundColor = UIColor(Color.theme.background)
        }
    
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
