//
//  KeyBoardExtension.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 17/2/22.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
