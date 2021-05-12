//
//  ViewController.swift
//  Assignment
//
//  Created by Nitin Singh on 11/05/21.
//

import UIKit

class BookmarkViewController: UIViewController {

    @IBOutlet weak var bookMarkTableView : UITableView!
    var editable = false
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        configure()
    }
    func configure(){
        bookMarkTableView.registerNib(BookmarkCell.self)
        WeatherDataService.shared.update { (status) in
            if status == .failure{
                self.showAlert(msg: "Something went wrong")
            }
        }
        bookMarkTableView.reloadData()
    }

    func showAlert(msg : String){
        let alertViewController = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            print("nothing")
        }
        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func barbuttonClicked(_ sender: Any) {
        let addBookmark = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddBookmarkViewController") as! AddBookmarkViewController
        self.navigationController?.pushViewController(addBookmark, animated: true)
    }
    @IBAction func mapbuttonClicked(_ sender: UIButton) {
        if editable{
            bookMarkTableView.isEditing = false
        }else{
            bookMarkTableView.isEditing = true
            editable = true
        }
    }
    func mapViewSelected(){
        let mapView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.navigationController?.pushViewController(mapView, animated: true)
    }
    
    func detailsViewSelected(weatherDto : WeatherStationDTO?){
        if let weather = weatherDto{
            UserLocationService.shared.currentLatitude = weather.coordinates.latitude
            UserLocationService.shared.currentLongitude = weather.coordinates.longitude
            let detailsView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            detailsView.weatherStationDTO = weatherDto
            self.navigationController?.pushViewController(detailsView, animated: true)
        }
    }
}

extension BookmarkViewController : UITableViewDelegate, UITableViewDataSource{
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeatherDataService.shared.bookmarkedLocations.count
     }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BookmarkCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let location = WeatherDataService.shared.bookmarkedLocations[indexPath.row]
        cell.contentLabel.text = location.name.append(contentsOf: location.country, delimiter: .comma)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
        let location = WeatherDataService.shared.bookmarkedLocations[indexPath.row]
        detailsViewSelected(weatherDto: location)
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return UITableView.automaticDimension
    }
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      true
    }
    
     func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
      false
    }
    
     func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
      true
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      
      defer {
        tableView.reloadData()
      }
      
      if editingStyle == .delete {
        WeatherDataService.shared.bookmarkedLocations.remove(at: indexPath.row)
      }
    }
    
     func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
      let movedLocation = WeatherDataService.shared.bookmarkedLocations[sourceIndexPath.row]
      WeatherDataService.shared.bookmarkedLocations.remove(at: sourceIndexPath.row)
      WeatherDataService.shared.bookmarkedLocations.insert(movedLocation, at: destinationIndexPath.row)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
      super.setEditing(editing, animated: animated)
      bookMarkTableView.reloadData()
    }
}
