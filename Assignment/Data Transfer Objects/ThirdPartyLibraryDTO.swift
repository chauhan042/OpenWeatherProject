

import Foundation

struct ThirdPartyLibraryArrayWrapper: Codable {
  var elements: [ThirdPartyLibraryDTO]
}

struct ThirdPartyLibraryDTO: Codable {
  var name: String
  var urlString: String
}
