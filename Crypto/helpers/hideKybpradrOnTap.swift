import SwiftUI
import UIKit

// Create an extension for UIApplication to add keyboard dismissal behavior
extension UIApplication {
    func addBackgroundTapGestureForKeyboardDismissal() {
        guard let keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        
        // Check if the gesture already exists to avoid adding multiple gestures
        if let existingGesture = keyWindow.gestureRecognizers?.first(where: { $0 is BackgroundTapGestureRecognizer }) {
            return
        }
        
        let tapGesture = BackgroundTapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = tapGesture
        keyWindow.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// Custom gesture recognizer that ignores taps on text input views
class BackgroundTapGestureRecognizer: UITapGestureRecognizer, UIGestureRecognizerDelegate {
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        self.delegate = self
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Find the view that was tapped
        let view = touch.view
        
        // Don't trigger for text input views or their subviews
        if let view = view {
            if view is UITextField || view is UITextView || view.isDescendant(of: UITextField()) || view.isDescendant(of: UITextView()) {
                return false
            }
        }
        return true
    }
}
