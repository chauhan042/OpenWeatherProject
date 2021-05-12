

import Foundation

struct PreferredBookmarkOption: Codable, PreferencesOption {
  typealias WrappedEnumType = Int?
  
  var value: Int?
  
  init(value: Int?) {
    self.value = value
  }
  
  init?(rawValue: Int) {
    return nil
  }
  
  var stringValue: String {
    let bookmarkedLocation = WeatherDataService.shared.bookmarkedLocations.first(where: { $0.identifier == value })
    return bookmarkedLocation?.name ?? ""
  }
}
