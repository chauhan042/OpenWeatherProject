//
//  AddBookmarkViewController.swift
//  Assignment
//
//  Created by Nitin Singh on 11/05/21.
//

import UIKit

class AddBookmarkViewController: UIViewController {

    @IBOutlet weak var addBookMarkTableView : UITableView!
    private var filteredCities = [WeatherStationDTO]() {
      didSet {
        DispatchQueue.main.async { [weak self] in
          self?.addBookMarkTableView.reloadData()
        }
      }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addBookMarkTableView.registerNib(SubtitleCell.self)
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "name"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        addBookMarkTableView.contentInset = UIEdgeInsets(
            top: 12.0,
          left: .zero,
            bottom: 12.0,
          right: .zero
        )
        
        definesPresentationContext = true
        // Do any additional setup after loading the view.
    }

}
extension AddBookmarkViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
      1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SubtitleCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
      cell.contentLabel.text = filteredCities[indexPath.row].name
      cell.subtitleLabel.text = ""
        .append(contentsOf: ConversionWorker.countryName(for: filteredCities[indexPath.row].country), delimiter: .comma)
      return cell
    }
    
    // MARK: - TableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      
      WeatherDataService.shared.bookmarkedLocations.append(filteredCities[indexPath.row])
      navigationController?.popViewController(animated: true)
    }
}
extension AddBookmarkViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = navigationItem.searchController?.searchBar.text else {
      filteredCities = [WeatherStationDTO]()
      addBookMarkTableView.reloadData()
      return
    }
    WeatherStationService.shared.locations(forSearchString: searchText, completionHandler: { [weak self] weatherLocationDTOs in
      if let weatherLocationDTOs = weatherLocationDTOs {
        self?.filteredCities = weatherLocationDTOs
      }
    })
  }
}

extension AddBookmarkViewController: UISearchControllerDelegate {
  
  func didDismissSearchController(_ searchController: UISearchController) {
    filteredCities = [WeatherStationDTO]()
    addBookMarkTableView.reloadData()
  }
}
