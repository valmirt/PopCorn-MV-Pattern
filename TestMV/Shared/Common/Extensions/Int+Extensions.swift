//
//  Int+Extensions.swift
//  TestMV
//
//  Created by Valmir Torres on 05/12/22.
//

import Foundation

extension Int {
    var toCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en-US")
        if let str = formatter.string(for: self) {
            return str
        }
        return "-"
    }
}
