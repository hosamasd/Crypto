//
//  EX_View.swift
//  PlayIT
//
//  Copyright © 2021 Bola Fayez. All rights reserved.
//

import SwiftUI
import Combine

extension UIBezierPath {
  var path: Path {
    return Path(self.cgPath)
  }

  func addQuadCurve(to point: CGPoint, control: CGPoint) {
    self.addQuadCurve(to: point, controlPoint: control)
  }

  convenience init(_ callback: (inout UIBezierPath) -> ()) {
    var path = UIBezierPath()
    callback(&path)
    self.init(cgPath: path.cgPath)
  }
}
struct viewModifierss: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .padding(.vertical,-4)
            .padding(.horizontal,4)
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 8)
                    .stroke(ColorConstants.lineColor, lineWidth: 1)
            )
            .backgroundColor(.white)
    }
}
struct viewModifiers: ViewModifier {
    var corner:CGFloat = 10
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(
                    cornerRadius: corner
                )
                .foregroundColor(Color.white)
                .shadow(
                    color: Color.gray.opacity(0.6),
                    radius: 2.5,
                    x: 0,
                    y: 2
                )
            )
    }
}


extension Font {

    /// Create a font with the large title text style.
      public static var customFont: Font {
          return Font.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
      }
    
    public static func customFontSystem(size: CGFloat) -> Font {
        return Font.custom("Lato-Regular", size:size)
 }
    
    public static func boldCustomFontSystem(size: CGFloat) -> Font {
        return Font.custom("Lato-Black", size:size)
 }
}

extension View {
    
    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
    
    func backgroundColor(_ color: Color) -> some View {
       return self.background(color)
     }
    //for add border specific location
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
    
  
    
    //for keyboard height
//    func KeyboardAwarePadding() -> some View {
//        ModifiedContent(content: self, modifier: KeyboardAwareModifier())
//    }
    
    func getSafeArea() -> UIEdgeInsets? {
        return UIApplication.shared.windows.first?.safeAreaInsets
    }
    
    func getFrameSize() -> CGRect {
        return UIScreen.main.bounds
    }
    
    func frameWidth() -> CGFloat {
        getFrameSize().width
    }
    
    func frameHeight() -> CGFloat {
        getFrameSize().height
    }
    
    func imageHeight() -> CGFloat {
        getFrameSize().height < 750 ? 300 : 350
    }
    
    func isSmallDevice() -> Bool {
        UIScreen.main.bounds.height < 750
    }
    
    func isSmallDeviceLand() -> Bool {
        UIScreen.main.bounds.width < 750
    }
    
    func isSmallDeviceLand2() -> Bool {
        UIScreen.main.bounds.width < 750 && UIScreen.main.bounds.height < 750
    }
    
    func isFaoundBottomSafe() -> CGFloat? {
        return   UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 0 : UIApplication.shared.windows.first?.safeAreaInsets.bottom
    }
    
    func bottomSafeArea(x:CGFloat,y:CGFloat = 0) -> CGFloat? {
        return   UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? x : (UIApplication.shared.windows.first?.safeAreaInsets.bottom)!+y
    }
}



let keyboardSpaceD = KeyboardSpace()
extension View {
    func keyboardSpace() -> some View {
        modifier(KeyboardSpace.Space(data: keyboardSpaceD))
    }
}

class KeyboardSpace: ObservableObject {
    var sub: AnyCancellable?
    
    @Published var currentHeight: CGFloat = 0
    var heightIn: CGFloat = 0 {
        didSet {
            withAnimation {
                if UIWindow.keyWindow != nil {
                    //fix notification when switching from another app with keyboard
                
                    self.currentHeight = heightIn
                }
            }
        }
    }
    
    init() {
        subscribeToKeyboardEvents()
    }
    
    private let keyboardWillOpen = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .map { $0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect }
        .map { $0.height - (UIWindow.keyWindow?.safeAreaInsets.bottom ?? 0) }
    
    private let keyboardWillHide =  NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map { _ in CGFloat.zero }
    
    private func subscribeToKeyboardEvents() {
        sub?.cancel()
        sub = Publishers.Merge(keyboardWillOpen, keyboardWillHide)
            .subscribe(on: RunLoop.main)
            .assign(to: \.self.heightIn, on: self)
    }
    
    deinit {
        sub?.cancel()
    }
    
    struct Space: ViewModifier {
        @ObservedObject var data: KeyboardSpace
        
        func body(content: Content) -> some View {
            VStack(spacing: 0) {
                content
                
                Rectangle()
                    .foregroundColor(Color(.clear))
                    .frame(height: data.currentHeight)
                    .frame(maxWidth: .greatestFiniteMagnitude)

            }
        }
    }
}

extension UIWindow {
    static var keyWindow: UIWindow? {
        let keyWindow = UIApplication.shared.connectedScenes
            .first { $0.activationState == .foregroundActive }
            .flatMap { $0 as? UIWindowScene }?.windows
            .first { $0.isKeyWindow }
        return keyWindow
    }
}
