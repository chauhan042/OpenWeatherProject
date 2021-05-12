

import UIKit

enum AmountOfResultsValue: Int, CaseIterable, Codable {
  case ten = 10
  case twenty = 20
  case thirty = 30
  case forty = 40
  case fifty = 50
}

struct AmountOfResultsOption: Codable, PreferencesOption {
  
  static let availableOptions = [AmountOfResultsOption(value: .ten),
                                 AmountOfResultsOption(value: .twenty),
                                 AmountOfResultsOption(value: .thirty),
                                 AmountOfResultsOption(value: .forty),
                                 AmountOfResultsOption(value: .fifty)]
  
  typealias PreferencesOptionType = AmountOfResultsValue
  
  private lazy var count = {
    return AmountOfResultsValue.allCases.count
  }()
  
  var value: AmountOfResultsValue
  
  init(value: AmountOfResultsValue) {
    self.value = value
  }
  
 init?(rawValue: Int) {
    guard let value = AmountOfResultsValue(rawValue: rawValue) else {
      return nil
    }
    self.init(value: value)
  }
  
  var stringValue: String {
    value.rawValue.append(contentsOf: "Results", delimiter: .space)
  }
  
  var integerValue: Int {
    value.rawValue
  }
}
