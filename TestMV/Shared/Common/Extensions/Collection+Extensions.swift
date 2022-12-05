//
//  Collection+Extensions.swift
//  TestMV
//
//  Created by Valmir Torres on 05/12/22.
//

import Foundation

extension Collection where Element == String {
    var desc: String {
        var desc = ""
        forEach { item in
            desc += "\(item) * "
        }
        desc.removeLast(3)
        return desc
    }
}
