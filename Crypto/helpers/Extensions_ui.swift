//
//  Extensions.swift
//  Chattos
//
//

import SwiftUI
import UIKit

let DEVICEID: String = "DEVICEID"

extension Int {

    var numberString: String {

        guard self < 10 else { return "0" }

        return String(self)
    }
}

extension String {
    
    var english: String {
        return self.applyingTransform(StringTransform.toLatin, reverse: false) ?? self
    }
    /// Returns String unicode value of country flag for iso code
    func getFlag() -> String {
        unicodeScalars
            .map { 127_397 + $0.value }
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
    
    var digits: [Int] {
        var result = [Int]()

        for char in self {
            if let number = Int(String(char)) {
                result.append(number)
            }
        }

        return result
    }
    
    var length: Int {
        return count
    }
    
    var localized:String {
        return NSLocalizedString(self, comment: "")
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    
    var isValidEmail: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool {
        let phoneNumberRegex = "^[1-1]\\d{10}$"
        //        let phoneNumberRegex = "^[0-0]\\d{10}$"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = phoneTest.evaluate(with: self)
        return self == "" ? true : isValidPhone
    }
    
    var isValidName: Bool {
        let nameRegEx = "^[A-Za-zء-ي-\\s]+$"
        return NSPredicate(format:"SELF MATCHES %@", nameRegEx).evaluate(with: self)
    }
    
    func toSecrueHttps() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
    
    var isValidPassword:  Bool {
          //let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[ !\"\\\\#$%&'()*+,-./:;<=>?@\\[\\]^_`{|}~])[A-Za-z\\d !\"\\\\#$%&'()*+,-./:;<=>?@\\[\\]^_`{|}~]{8,}"
          //safe to escape all regex chars
          let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[ !\"\\\\#$%&'\\(\\)\\*+,\\-\\./:;<=>?@\\[\\]^_`\\{|\\}~])[A-Za-z\\d !\"\\\\#$%&'\\(\\)\\*+,\\-\\./:;<=>?@\\[\\]^_`\\{|\\}~]{8,}"
          return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
      }
}

struct BlurView: UIViewRepresentable {
    
    let style: UIBlurEffect.Style
    
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView,
                      context: UIViewRepresentableContext<BlurView>) {
        
    }
    
}



struct EdgeBorder: Shape {
    
    var width: CGFloat
    var edges: [Edge]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }
            
            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }
            
            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }
            
            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}

extension Comparable {
  func clampFrom(min minValue: Self, to maxValue: Self) -> Self {
    let clampedToMin = [minValue, self].max() ?? minValue
    let clampedToBoth = [clampedToMin, maxValue].min() ?? maxValue
    return clampedToBoth
  }
}

extension UIImage {
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}



extension UIImageView {
    //for change img background as color
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

//for problem of back navlink automitic

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

//extension View {
//    func navigate<Destination: View>(
//        isActive: Binding<Bool>,
//        destination: Destination?
//    ) -> some View {
//        background(
//            NavigationLink(
//                destination: destination,
//                isActive: isActive,
//                label: EmptyViews.init
//            )
//            .hidden()
//        )
//    }
//}
//extension View {
//    func navigate<Item, Destination: View>(
//        item: Binding<Item?>,
//        destination: (Item) -> Destination
//    ) -> some View {
//        navigate(
//            isActive: Binding(
//                get: { item.wrappedValue != nil },
//                set: { if !$0 { item.wrappedValue = nil } }
//            ),
//            destination: Group {
//                if let item = item.wrappedValue {
//                    destination(item)
//                }
//            }
//        )
//    }
//}
