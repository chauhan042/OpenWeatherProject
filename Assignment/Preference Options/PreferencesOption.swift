
import Foundation

protocol PreferencesOption {
  associatedtype PreferencesOptionType
  var value: PreferencesOptionType { get set }
  init(value: PreferencesOptionType)
  init?(rawValue: Int)
  var stringValue: String { get }
}
