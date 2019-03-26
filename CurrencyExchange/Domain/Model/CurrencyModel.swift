//
//  CurrencyModel.swift
//  CurrencyExchange
//
//  Created by Toshihiro Nojima on 2019/03/22.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import UIKit

class CurrencyModel {
    
    var code: CurrencyCode
    var rate: Double
    var amount: Double
    
    static let maxDicimalPlaces = 3
    static let maxDigit = 8
    
    init(code: CurrencyCode, rate: Double, amount: Double) {
        self.code = code
        self.rate = rate
        self.amount = amount
    }
}

extension CurrencyModel: Equatable {
    
    static func == (lhs: CurrencyModel, rhs: CurrencyModel) -> Bool {
        guard lhs.code == rhs.code,
            lhs.rate == rhs.rate,
            lhs.amount == rhs.amount else {
                return false
        }
        return true
    }
}

enum CurrencyCode: String {
    case EUR
    case AUD
    case BGN
    case BRL
    case CAD
    case CHF
    case CNY
    case CZK
    case DKK
    case GBP
    case HKD
    case HRK
    case HUF
    case IDR
    case ILS
    case INR
    case ISK
    case JPY
    case KRW
    case MXN
    case MYR
    case NOK
    case NZD
    case PHP
    case PLN
    case RON
    case RUB
    case SEK
    case SGD
    case THB
    case TRY
    case USD
    case ZAR
    
    func getCurrencyName() -> String {
        switch self {
        case .EUR: return "Euro"
        case .AUD: return "Australian Dollar"
        case .BGN: return "Bulgarian Lev"
        case .BRL: return "Brazilian Real"
        case .CAD: return "Canadian Dollar"
        case .CHF: return "Swiss Franc"
        case .CNY: return "Renminbi Yuan"
        case .CZK: return "Czech Koruna"
        case .DKK: return "Danish Krone"
        case .GBP: return "Pound Sterling"
        case .HKD: return "Hong Kong Dollar"
        case .HRK: return "Croatian Kuna"
        case .HUF: return "Hungarian Forint"
        case .IDR: return "Indonesian Rupiah"
        case .ILS: return "Israeli New Shekel"
        case .INR: return "Indian Rupee"
        case .ISK: return "Icelandic Króna"
        case .JPY: return "Japanese Yen"
        case .KRW: return "South Korean Won"
        case .MXN: return "Mexican Peso"
        case .MYR: return "Malaysian Ringgit"
        case .NOK: return "Norwegian Krone"
        case .NZD: return "New Zealand Dollar"
        case .PHP: return "Philippine Peso"
        case .PLN: return "Polish Złoty"
        case .RON: return "Romanian Leu"
        case .RUB: return "Russian Ruble"
        case .SEK: return "Swedish Krona"
        case .SGD: return "Singapore Dollar"
        case .THB: return "Thai Baht"
        case .TRY: return "Turkish Lira"
        case .USD: return "United States Dollar"
        case .ZAR: return "South African Rand"
        }
    }
    
    func getNationalFlag() -> UIImage? {
        return UIImage(named: rawValue)
    }
    
    func getSymbol() -> String {
        switch self {
        case .EUR: return "€"
        case .AUD: return "$"
        case .BGN: return "лв."
        case .BRL: return "R$"
        case .CAD: return "$"
        case .CHF: return "₣"
        case .CNY: return "¥"
        case .CZK: return "Kč"
        case .DKK: return "kr"
        case .GBP: return "£"
        case .HKD: return "$"
        case .HRK: return "kn"
        case .HUF: return "Ft"
        case .IDR: return "Rp"
        case .ILS: return "₪"
        case .INR: return "₹"
        case .ISK: return "kr"
        case .JPY: return "¥"
        case .KRW: return "₩"
        case .MXN: return "$"
        case .MYR: return "RM"
        case .NOK: return "kr"
        case .NZD: return "$"
        case .PHP: return "₱"
        case .PLN: return "zł"
        case .RON: return "RON"
        case .RUB: return "₽"
        case .SEK: return "kr"
        case .SGD: return "$"
        case .THB: return "฿"
        case .TRY: return "₺"
        case .USD: return "$"
        case .ZAR: return "R"
        }
    }
}
