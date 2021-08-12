//
//  CustomNumberFormatter.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/12.
//

import Foundation

struct CustomNumberFormatter {
    static let commaFormatter: NumberFormatter = {
        let numberFomatter = NumberFormatter()
        numberFomatter.numberStyle = .decimal
        
        return numberFomatter
    }()
}
