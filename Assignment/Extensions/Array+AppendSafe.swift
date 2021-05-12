

import Foundation

extension Array {
  
  mutating func appendSafe(_ element: Element?) {
    guard let element = element else { return }
    append(element)
  }
}
