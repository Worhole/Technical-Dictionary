//
//  HideKeyBoard.swift
//  Technical Dictionary
//
//  Created by 71m3 on 2025-04-09.
//

import UIKit

class HideKeyBoard {
    static let shared = HideKeyBoard();private init(){}
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
