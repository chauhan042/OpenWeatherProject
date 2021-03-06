

import Foundation
import FMDB

let locationsSQLiteSqlite =  Bundle.main.path(forResource: "locationsSQLite", ofType: "sqlite")

final class WeatherStationService {
  
  // MARK: - Public Assets
  
  static let shared = WeatherStationService()
  
  // MARK: - Private Assets
  
  private lazy var openWeatherMapCityServiceBackgroundQueue: DispatchQueue = {
    return DispatchQueue(label: Constants.Labels.DispatchQueues.kOpenWeatherMapCityServiceBackgroundQueue,
                         qos: .userInitiated,
                         attributes: [.concurrent],
                         autoreleaseFrequency: .inherit,
                         target: nil)
  }()
  
  fileprivate let databaseQueue: FMDatabaseQueue
  
  // MARK: - Initialization
  
  private init() {
    let sqliteFilePath = locationsSQLiteSqlite // crash app if not found, cannot run without db
    self.databaseQueue = FMDatabaseQueue(path: sqliteFilePath)! // crash app if init fails, cannot run without db
  }
  
  // MARK: - Public Properties & Methods
  
  func locations(forSearchString searchString: String, completionHandler: @escaping (([WeatherStationDTO]?) -> Void)) {
    
    if searchString.isEmpty || searchString == "" { return completionHandler(nil) }
    
    openWeatherMapCityServiceBackgroundQueue.async {
      self.databaseQueue.inDatabase { database in
        let usedLocationIdentifiers = WeatherDataService.shared.bookmarkedLocations.compactMap {
          String($0.identifier)
        }
        
        let sqlUsedLocationsIdentifiersArray = "('" + usedLocationIdentifiers.joined(separator: "','") + "')"
        
        let query = !usedLocationIdentifiers.isEmpty
          ? "SELECT * FROM locations l WHERE l.id NOT IN \(sqlUsedLocationsIdentifiersArray) AND (lower(name) LIKE '%\(searchString.lowercased())%') ORDER BY country, l.name"
          : "SELECT * FROM locations l WHERE (lower(name) LIKE '%\(searchString.lowercased())%') ORDER BY l.name, l.country"
        
        guard let result = try? database.executeQuery(query, values: nil) else {
          completionHandler(nil)
          return
        }
        
        var retrievedLocations = [WeatherStationDTO]()
        while result.next() {
          guard let location = WeatherStationDTO(from: result) else {
            return
          }
          retrievedLocations.append(location)
        }
        
        guard !retrievedLocations.isEmpty else {
          return completionHandler(nil)
        }
        completionHandler(retrievedLocations)
      }
    }
  }
}
