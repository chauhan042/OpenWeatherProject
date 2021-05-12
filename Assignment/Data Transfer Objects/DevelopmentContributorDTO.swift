

import Foundation

struct DevelopmentContributorArrayWrapper: Codable {
  var elements: [DevelopmentContributorDTO]
}

struct DevelopmentContributorDTO: Codable {
  var firstName: String
  var lastName: String
  var contributionDescription: [String: String]
  var urlString: String
  
  var localizedContributionDescription: String? {
    return contributionDescription
      .first { $0.key == Locale.current.languageCode?.lowercased() ?? "en" }?
      .value
  }
}
