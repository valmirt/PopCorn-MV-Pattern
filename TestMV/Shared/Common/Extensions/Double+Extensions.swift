//
//  Double+Extensions.swift
//  TestMV
//
//  Created by Valmir Torres on 04/12/22.
//

import Foundation

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
