//
//  ISO4217_CurrencyCode.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/27.
//

enum CurrencyCode: String, CaseIterable, CustomStringConvertible {
    case Euro = "Euro"
    case USDollar = "US Dollar"
    case Won = "Won"
    case Yen = "Yen"
    case YuanRenminbi = "Yuan Renminbi"
    case CzechKoruna = "Czech Koruna"
    case Baht = "Baht"
    case Dong = "Dong"

    var description: String {
        switch self {
        case .Euro: return "EUR"
        case .USDollar: return "USD"
        case .Won: return "KRW"
        case .Yen: return "JPY"
        case .YuanRenminbi: return "CNY"
        case .CzechKoruna: return "CZK"
        case .Baht: return "THB"
        case .Dong: return "VND"
        }
    }
    
    static let list: [CurrencyCode] = {
        var codes = [CurrencyCode]()
        for code in CurrencyCode.allCases {
            codes.append(code)
        }
        return codes
    }()
}
