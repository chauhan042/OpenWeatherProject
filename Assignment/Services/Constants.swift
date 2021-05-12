//
//  Constants.swift
//  Assignment
//
//  Created by Nitin Singh on 11/05/21.
//

import Foundation
/// API Constants

enum Constants {}


extension Constants {
  enum Labels {}
}

extension Constants.Labels {
  
  enum DispatchQueues {
    static let kOpenWeatherMapCityServiceBackgroundQueue = "queue.Weather.openWeatherMapCityService"
    static let kFetchWeatherDataBackgroundQueue = "queue.Weather.fetchWeatherDataQueue"
    static let kWeatherServiceBackgroundQueue = "queue.Weather.weatherDataManagerBackgroundQueue"
    static let kPreferencesManagerBackgroundQueue = "queue.Weather.preferencesManagerBackgroundQueue"
    static let kWeatherFetchQueue = "queue.Weather.weatherFetchQueue"
  }
}

extension Constants {
  enum Keys {}
}

extension Constants.Keys {
  
  enum NotificationCenter {
    static let kWeatherServiceDidUpdate = "weatherServiceDidUpdate"
    static let kLocationAuthorizationUpdated = "locationAuthorizationUpdated"
    static let kNetworkReachabilityChanged = "networkReachabilityChanged"
    static let kSortingOrientationPreferenceChanged = "sortingOrientationPreferenceChanged"
  }
}
extension Constants.Keys {
  
  enum UserDefaults {
    static let kNearbyWeatherApiKeyKey = "openWeatherMapApiKey"
    static let kIsInitialLaunch = "isInitialLaunch"
  }
}


extension Constants.Keys {
  
  enum NotificationIdentifiers {
    static let kAppIconTemeperatureNotification = "AppIconTemeperatureNotification"
  }
}

extension Constants.Keys {
  
  enum KeyValueBindings {
    static let kImage = "image"
    static let kChecked = "checked"
  }
}

extension Constants.Keys {
  
  enum Storage {
    static let kWeatherDataManagerStoredContentsFileName = "WeatherDataManagerStoredContents"
    static let kPreferencesManagerStoredContentsFileName = "PreferencesManagerStoredContents"
  }
}

extension Constants.Keys {
  
  enum MapAnnotation {
    static let kMapAnnotationViewIdentifier = "WeatherLocationMapAnnotationView"
  }
}

extension Constants.Keys {
  
  enum ApiKey {
    static let key = "fae7190d7e6433ec3a45285ffcf55c86"
  }
}






extension Constants {
  enum Values {}
}

extension Constants.Values {
  
  enum TemperatureName {
    static let kCelsius = "Celsius"
    static let kFahrenheit = "Fahrenheit"
    static let kKelvin = "Kelvin"
  }
}

extension Constants.Values {
  
  enum TemperatureUnit {
    static let kCelsius = "°C"
    static let kFahrenheit = "°F"
    static let kKelvin = "K"
  }
}

extension Constants {
  
  enum Urls {
    static let kOpenWeatherSingleLocationBaseUrl = URL(string: "http://api.openweathermap.org/data/2.5/weather")!
    static let kOpenWeatherMultiLocationBaseUrl = URL(string: "http://api.openweathermap.org/data/2.5/find")!
    static let kOpenWeatherMultiDaysBaseUrl = URL(string: "http://api.openweathermap.org/data/2.5/forecast")!
    static let kOpenWeatherMapUrl = URL(string: "https://openweathermap.org")!
    static let kOpenWeatherMapInstructionsUrl = URL(string: "https://openweathermap.org/appid")!
    
    static func kOpenWeatherMapCityDetailsUrl(forCityWithName name: String) -> URL {
      return URL(string: "https://openweathermap.org/find?q=\(name)")!
    }
    static let KHowtoStart = "https://openweathermap.org/appid"
    static func kOpenWeatherMapSingleStationtDataRequestUrl(with apiKey: String, stationIdentifier identifier: Int) -> URL {
      let localeTag = Locale.current.languageCode?.lowercased() ?? "en"
      let baseUrl = Constants.Urls.kOpenWeatherSingleLocationBaseUrl.absoluteString
        return URL(string: "\(baseUrl)?APPID=\(Constants.Keys.ApiKey.key)&id=\(identifier)&lang=\(localeTag)")!
    }
    
    static func kOpenWeatherMapMultiStationtDataRequestUrl(with latitude: Double, currentLongitude longitude: Double) -> URL {
      let baseUrl = Constants.Urls.kOpenWeatherMultiLocationBaseUrl.absoluteString
      let numberOfResults = PreferencesDataService.shared.amountOfResults.integerValue
      return URL(string: "\(baseUrl)?APPID=\(Constants.Keys.ApiKey.key)&lat=\(latitude)&lon=\(longitude)&cnt=\(numberOfResults)")!
    }
    
    static func kOpenWeatherMapForeCastUrl(with latitude: Double, currentLongitude longitude: Double) -> URL {
      let baseUrl = Constants.Urls.kOpenWeatherMultiDaysBaseUrl.absoluteString
      return URL(string: "\(baseUrl)?APPID=\(Constants.Keys.ApiKey.key)&lat=\(latitude)&lon=\(longitude)")!
    }
  }
}


extension Constants {
  enum Mocks {}
}

extension Constants.Mocks {
  
  enum WeatherStationDTOs {
    static let kDefaultBookmarkedLocation = WeatherStationDTO(
      identifier: 1266014,
      name: "Kotdwāra",
      state: "nil",
      country: "IN",
      coordinates: Coordinates(latitude: 29.75, longitude: 78.533333)
    )
  }
}
