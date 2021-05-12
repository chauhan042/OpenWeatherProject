//
//  MapViewController.swift
//  Assignment
//
//  Created by Nitin Singh on 11/05/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    private var mapView: MKMapView!
    var weatherLocationMapAnnotations: [WeatherLocationMapAnnotation]!
    
    private var selectedBookmarkedLocation: WeatherStationDTO?
    private var previousRegion: MKCoordinateRegion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        configureMapAnnotations()
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(Self.reconfigureOnWeatherDataServiceDidUpdate),
          name: Notification.Name(rawValue: Constants.Keys.NotificationCenter.kWeatherServiceDidUpdate),
          object: nil
        )
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        selectedBookmarkedLocation = WeatherDataService.shared.bookmarkedLocations.first
        
      
      focusOnAvailableLocation()
    }

    func configureMapView() {
      mapView = MKMapView()
      
      mapView.delegate = self
        mapView.mapType = .standard
      
      view.addSubview(mapView, constraints: [
        mapView.topAnchor.constraint(equalTo: view.topAnchor),
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
      ])
    }
    deinit {
      NotificationCenter.default.removeObserver(self)
    }
}
private extension MapViewController {
    
    func configureMapAnnotations() {
        // remove previous annotations
        mapView.annotations.forEach { mapView.removeAnnotation($0) }
        
        // calculate current annotations
        weatherLocationMapAnnotations = [WeatherLocationMapAnnotation]()
        
        let bookmarkedLocationAnnotations: [WeatherLocationMapAnnotation]? = WeatherDataService.shared.bookmarkedWeatherDataObjects?.compactMap {
            guard let weatherDTO = $0.weatherInformationDTO else { return nil }
            return WeatherLocationMapAnnotation(weatherDTO: weatherDTO, isBookmark: true)
        }
        weatherLocationMapAnnotations.append(contentsOf: bookmarkedLocationAnnotations ?? [WeatherLocationMapAnnotation]())
        
        let nearbyocationAnnotations = WeatherDataService.shared.nearbyWeatherDataObject?.weatherInformationDTOs?.compactMap {
            return WeatherLocationMapAnnotation(weatherDTO: $0, isBookmark: false)
        }
        weatherLocationMapAnnotations.append(contentsOf: nearbyocationAnnotations ?? [WeatherLocationMapAnnotation]())
        
        // add current annotations
        mapView.addAnnotations(weatherLocationMapAnnotations)
    }
    
    func focusMapOnUserLocation() {
        if UserLocationService.shared.locationPermissionsGranted, let currentLocation = UserLocationService.shared.currentLocation {
            let region = MKCoordinateRegion.init(center: currentLocation.coordinate, latitudinalMeters: 15000, longitudinalMeters: 15000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func focusMapOnSelectedBookmarkedLocation() {
        guard let selectedLocation = selectedBookmarkedLocation else {
            return
        }
        let coordinate = CLLocationCoordinate2D(latitude: selectedLocation.coordinates.latitude, longitude: selectedLocation.coordinates.longitude)
        let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 15000, longitudinalMeters: 15000)
        mapView.setRegion(region, animated: true)
    }
    
    func focusOnAvailableLocation() {
        if let previousRegion = previousRegion {
            mapView.setRegion(previousRegion, animated: true)
            return
        }
        guard UserLocationService.shared.locationPermissionsGranted, UserLocationService.shared.currentLocation != nil else {
            focusMapOnSelectedBookmarkedLocation()
            return
        }
        focusMapOnUserLocation()
    }
    @objc private func reconfigureOnWeatherDataServiceDidUpdate() {
        configureMapAnnotations()
    }
}
extension MapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? WeatherLocationMapAnnotation else {
      return nil
    }
    
    var viewForCurrentAnnotation: WeatherLocationMapAnnotationView?
    if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.Keys.MapAnnotation.kMapAnnotationViewIdentifier) as? WeatherLocationMapAnnotationView {
      viewForCurrentAnnotation = dequeuedAnnotationView
    } else {
      viewForCurrentAnnotation = WeatherLocationMapAnnotationView(frame: kMapAnnotationViewInitialFrame)
    }
    
    var fillColor: UIColor
    var textColor: UIColor
    
    if annotation.isBookmark {
      fillColor = annotation.isDayTime ?? true
        ? UIColor.white
        : UIColor.black // default to blue colored cells
      
      textColor = .white
    } else {
      fillColor = .white
      textColor = .black
    }
    
    viewForCurrentAnnotation?.annotation = annotation
    viewForCurrentAnnotation?.configure(
      withTitle: annotation.title ?? "Not Set",
      subtitle: annotation.subtitle ?? "Not Set",
      fillColor: fillColor,
      textColor: textColor,
      tapHandler: { [weak self] _ in
        self?.previousRegion = mapView.region
//        self?.steps.accept(
//          MapStep.weatherDetails(identifier: annotation.locationId, isBookmark: annotation.isBookmark)
//        )
      }
    )
    return viewForCurrentAnnotation
  }
}
