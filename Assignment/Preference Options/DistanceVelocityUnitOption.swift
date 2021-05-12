
import Foundation

enum DistanceVelocityUnitValue: Int, CaseIterable, Codable {
  case kilometres
  case miles
}

struct DistanceVelocityUnitOption: Codable, PreferencesOption {
  static let availableOptions = [DistanceVelocityUnitOption(value: .kilometres),
                                 DistanceVelocityUnitOption(value: .miles)]
  
  typealias PreferencesOptionType = DistanceVelocityUnitValue
  
  private lazy var count = {
    return DistanceVelocityUnitValue.allCases.count
  }()
  
  var value: DistanceVelocityUnitValue
  
  init(value: DistanceVelocityUnitValue) {
    self.value = value
  }
  
  init?(rawValue: Int) {
    guard let value = DistanceVelocityUnitValue(rawValue: rawValue) else {
      return nil
    }
    self.init(value: value)
  }
  
  var stringValue: String {
    switch value {
    case .kilometres:
      return "Metric"
    case .miles:
      return "Imperial"
    }
  }
}
