//
//  LocalizedString.swift
//  Weather
//
//  Created by Vandana Kanwar on 24/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import Foundation
enum LocalizedString: CustomStringConvertible {
    case temperatureString(Int)
    case details(String, Int, Int)
    case imageUrlString(String)
    case percentageValue(Int)
    case pressureUnitValue(Float)
    case humidityString
    case feelsLikeString
    case pressureString
    case sunriseString
    case sunsetString
    case chanceOfRainString
    case precipitationString
    case windString
    case cmUnitValue(Float)
    case windUnitString(Float)
    case nowString
    case errorText
    case initialValue
    case dayNameValue(String)
    case searchPlaceholder
    case alertTitle
    case alertSubtitle
    case alertButtonText
    case searchHistoryText
    case moreDetails

    var description: String {
        switch self {
        case let .temperatureString(temp):
            return localizeString("temperatureString",
                                  comment: "temp",
                                  temp)
        case let .details(today, temp, max):
            return localizeString("weatherDetails",
                                  comment: "imageUrlString",
                                  today, temp, max)
        case let .imageUrlString(urlString):
            return localizeString("imageUrlString",
                                  comment: "urlString",
                                  urlString)
        case let .percentageValue(value):
            return localizeString("percentageValue",
                                  comment: "percentageValue",
                                  value)
        case let .pressureUnitValue(value):
            return localizeString("pressureUnitValue",
                                  comment: "pressureUnitValue",
                                  value)
        case .humidityString:
            return localizeString("humidityString",
                                  comment: "humidityString")
        case .feelsLikeString:
            return localizeString("feelsLikeString",
                                  comment: "feelsLikeString")
        case .pressureString:
            return localizeString("pressureString",
                                  comment: "pressureString")
        case .sunriseString:
            return localizeString("sunriseString",
                                  comment: "sunriseString")
        case .sunsetString:
            return localizeString("sunsetString",
                                  comment: "sunsetString")
        case .chanceOfRainString:
            return localizeString("chanceOfRainString",
                                  comment: "chanceOfRainString")
        case .precipitationString:
            return localizeString("precipitationString",
                                  comment: "precipitationString")
        case .windString:
            return localizeString("windString",
                                  comment: "windString")
        case let .cmUnitValue(value):
            return localizeString("cmUnitValue",
                                  comment: "cmUnitValue",
                                  value)
        case let .windUnitString(value):
            return localizeString("windUnitString",
                                  comment: "windUnitString",
                                  value)
        case .nowString:
            return localizeString("nowString",
                                  comment: "nowString")
        case .errorText:
            return localizeString("errorText",
                                  comment: "errorText")
        case .initialValue:
            return localizeString("initialValue",
                                  comment: "initialValue")
        case let .dayNameValue(value):
            return localizeString("dayNameValue",
                                  comment: "dayNameValue",
                                  value)
        case .searchPlaceholder:
            return localizeString("searchPlaceholder",
                                  comment: "searchPlaceholder")
        case .alertTitle:
            return localizeString("alertTitle",
                                  comment: "alertTitle")
        case .alertSubtitle:
            return localizeString("alertSubtitle",
                                  comment: "alertSubtitle")
        case .alertButtonText:
            return localizeString("alertButtonText",
                                  comment: "alertButtonText")
        case .searchHistoryText:
            return localizeString("searchHistoryText",
                                  comment: "searchHistoryText")
        case .moreDetails:
            return localizeString("moreDetails",
                                  comment: "moreDetails")
        }
    }
}

extension LocalizedString {
    private func localizeString(_ key: String, comment: String, _ arguments: CVarArg...) -> String {
        let format = NSLocalizedString(key,
                                       tableName: nil,
                                       bundle: Bundle(for: BundleIdentifierClass.self),
                                       comment: comment)
        return String(format: format, locale: Locale.current, arguments: arguments)
    }
}

private final class BundleIdentifierClass {}
