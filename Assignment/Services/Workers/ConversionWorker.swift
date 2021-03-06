

import Foundation
import MapKit

final class ConversionWorker {
  
  static func weatherConditionSymbol(fromWeatherCode code: Int?, isDayTime: Bool) -> String {
    guard let code = code else {
      return "❓"
    }
    switch code {
    case let x where (x >= 200 && x <= 202) || (x >= 230 && x <= 232):
      return "⛈"
    case let x where x >= 210 && x <= 211:
      return "🌩"
    case let x where x >= 212 && x <= 221:
      return "⚡️"
    case let x where x >= 300 && x <= 321:
      return "🌦"
    case let x where x >= 500 && x <= 531:
      return "🌧"
    case let x where x >= 600 && x <= 602:
      return "☃️"
    case let x where x >= 603 && x <= 622:
      return "🌨"
    case let x where x >= 701 && x <= 771:
      return "🌫"
    case let x where x == 781 || x == 900:
      return "🌪"
    case let x where x == 800:
      return isDayTime ? "☀️" : "🌕"
    case let x where x == 801:
      return "🌤"
    case let x where x == 802:
      return "⛅️"
    case let x where x == 803:
      return "🌥"
    case let x where x == 804:
      return "☁️"
    case let x where x >= 952 && x <= 956 || x == 905:
      return "🌬"
    case let x where x >= 957 && x <= 961 || x == 771:
      return "💨"
    case let x where x == 901 || x == 902 || x == 962:
      return "🌀"
    case let x where x == 903:
      return "❄️"
    case let x where x == 904:
      return "🌡"
    case let x where x == 962:
      return "🌋"
    default:
      return "❓"
    }
  }
  
  static func temperatureIntValue(forTemperatureUnit temperatureUnit: TemperatureUnitOption, fromRawTemperature rawTemperature: Double) -> Int? {
    let adjustedTemp: Double
    switch temperatureUnit.value {
    case .celsius:
      adjustedTemp = rawTemperature - 273.15
    case . fahrenheit:
      adjustedTemp = rawTemperature * (9/5) - 459.67
    case .kelvin:
      adjustedTemp = rawTemperature
    }
    
    guard !adjustedTemp.isNaN && adjustedTemp.isFinite else { return nil }
    return Int(adjustedTemp.rounded())
  }
  
  static func temperatureDescriptor(forTemperatureUnit temperatureUnit: TemperatureUnitOption, fromRawTemperature rawTemperature: Double) -> String {
    switch temperatureUnit.value {
    case .celsius:
      return String(format: "%.02f", rawTemperature - 273.15).append(contentsOf: "°C", delimiter: .none)
    case . fahrenheit:
      return String(format: "%.02f", rawTemperature * (9/5) - 459.67).append(contentsOf: "°F", delimiter: .none)
    case .kelvin:
      return String(format: "%.02f", rawTemperature).append(contentsOf: "°K", delimiter: .none)
    }
  }
  
  static func windspeedDescriptor(forDistanceSpeedUnit distanceSpeedUnit: DistanceVelocityUnitOption, forWindspeed windspeed: Double) -> String {
    switch distanceSpeedUnit.value {
    case .kilometres:
      return String(format: "%.02f", windspeed).append(contentsOf: "kph", delimiter: .space)
    case .miles:
      return String(format: "%.02f", windspeed / 1.609344).append(contentsOf: "mph", delimiter: .space)
    }
  }
  
  static func distanceDescriptor(forDistanceSpeedUnit distanceSpeedUnit: DistanceVelocityUnitOption, forDistanceInMetres distance: Double) -> String {
    switch distanceSpeedUnit.value {
    case .kilometres:
      return String(format: "%.02f", distance/1000).append(contentsOf: "km", delimiter: .space)
    case .miles:
      return String(format: "%.02f", distance/1609.344).append(contentsOf: "mi", delimiter: .space)
    }
  }
  
  static func windDirectionDescriptor(forWindDirection degrees: Double) -> String {
    return String(format: "%.02f", degrees).append(contentsOf: "°", delimiter: .none)
  }
  
  static func countryName(for countryCode: String) -> String? {
    Locale.current.localizedString(forRegionCode: countryCode)
  }
  
//  static func usStateName(for stateCode: String) -> String? {
//    UnitedStatesOfAmericaStatesList.statesDictionary[stateCode]
//  }
}
