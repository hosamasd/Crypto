//
//  Untitled.swift
//  Crypto
//
//  Created by hosam on 05/07/2026.
//
import SwiftUI

class HapticManager {
    
    static private let  generator=UINotificationFeedbackGenerator()
    
    static func notification(type:UINotificationFeedbackGenerator.FeedbackType)  {
        generator.notificationOccurred(type)
    }
}
