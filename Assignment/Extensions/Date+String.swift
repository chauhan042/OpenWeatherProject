
import Foundation

extension Date {
  
  var shortDateTimeString: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    
    return dateFormatter.string(from: self)
  }
}
