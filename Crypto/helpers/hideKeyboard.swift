//
//  hideKeyboard.swift
//  Login for Shimmer
//
//

import SwiftUI
import Foundation






func saveCurrentDate() {
    let currentDate = Date()
    UserDefaults.standard.set(currentDate, forKey: "lastSavedDate")
}


func hasDateChanged() -> Bool {
    guard let lastSavedDate = UserDefaults.standard.object(forKey: "lastSavedDate") as? Date else {
        // If there is no saved date, assume the date has changed
        saveCurrentDate()
        return true
    }

    let calendar = Calendar.current
    let currentDate = Date()
    
    if !calendar.isDate(lastSavedDate, inSameDayAs: currentDate) {
        // Save the new date if the date has changed
        saveCurrentDate()
        return true
    }
    
    return false
}



func isSavedDateToday() -> Bool {
    guard let lastSavedDate = UserDefaults.standard.object(forKey: "lastSavedDate") as? Date else {
        // If there is no saved date, return false
        return false
    }
    
    let calendar = Calendar.current
    return calendar.isDateInToday(lastSavedDate)
}


extension View {
//    func hideKeyboardOnTap() -> some View {
//        self.modifier(HideKeyboardOnTapModifier())
//    }
    
    func hideKeyboard() {
           UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
       }
}

struct HideKeyboardOnTapModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                let keyWindow = UIApplication.shared.connectedScenes
                    .filter { $0.activationState == .foregroundActive }
                    .map { $0 as? UIWindowScene }
                    .compactMap { $0 }
                    .first?.windows
                    .filter { $0.isKeyWindow }.first
                
                if let keyWindow = keyWindow {
                    let tapLocation = keyWindow.gestureRecognizers?.first?.location(in: keyWindow)
                    let textField = keyWindow.findTextField(at: tapLocation ?? .zero)
                    
                    if textField == nil {
                        keyWindow.endEditing(true)
                    }
                }
            }
    }
}

extension UIWindow {
    func findTextField(at point: CGPoint) -> UIView? {
        if let hitView = hitTest(point, with: nil) {
            return findTextField(in: hitView)
        }
        return nil
    }
    
    private func findTextField(in view: UIView) -> UIView? {
        if view is UITextField || view is UITextView {
            return view
        }
        
        for subview in view.subviews {
            if let found = findTextField(in: subview) {
                return found
            }
        }
        
        return nil
    }
}


//hide keyboard when tap around

extension UIApplication {
    
    
    
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true // set to `false` if you don't want to detect tap during other gestures
//    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return !otherGestureRecognizer.isKind(of: UILongPressGestureRecognizer.self)
    }
}

extension String {
    
//    func convertDateFormat(inputDate: String) -> String {
//
//         let olDateFormatter = DateFormatter()
//         olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//
//         let oldDate = olDateFormatter.date(from: inputDate)
//
//         let convertDateFormatter = DateFormatter()
//         convertDateFormatter.dateFormat = "MMM dd yyyy h:mm a"
//
//         return convertDateFormatter.string(from: oldDate!)
//    }
    
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}
