//
//  DetailsViewController.swift
//  Assignment
//
//  Created by Nitin Singh on 11/05/21.
//
import UIKit
import Foundation
import CoreLocation
import AddressBookUI




class DetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    private var weatherInformationDTOs: [WeatherListDTO]?
    
    @IBOutlet weak var currentHighLbl: UILabel!
    @IBOutlet weak var currentLowLbl: UILabel!
    @IBOutlet weak var hourlyForecastCollectionView: UICollectionView!
    @IBOutlet weak var dailyForecastCollectionView: UICollectionView!
    
    private var titleString: String!
    private var weatherDTO: WeatherListDTO?
    var weatherStationDTO: WeatherStationDTO!
    private var isBookmark: Bool!
    
    /* Outlets */
    
    @IBOutlet weak var conditionSymbolLabel: UILabel!
    @IBOutlet weak var conditionNameLabel: UILabel!
    @IBOutlet weak var conditionDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var daytimeStackView: UIStackView!
    
    @IBOutlet weak var cloudCoverImageView: UIImageView!
    @IBOutlet weak var cloudCoverNoteLabel: UILabel!
    @IBOutlet weak var cloudCoverLabel: UILabel!
    @IBOutlet weak var humidityImageView: UIImageView!
    @IBOutlet weak var humidityNoteLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureImageView: UIImageView!
    @IBOutlet weak var pressureNoteLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var windSpeedStackView: UIStackView!
    @IBOutlet weak var windSpeedImageView: UIImageView!
    @IBOutlet weak var windSpeedNoteLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionStackView: UIStackView!
    @IBOutlet weak var windDirectionImageView: UIImageView!
    @IBOutlet weak var windDirectionNoteLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    
    @IBOutlet var collectionHeightConstraints: NSLayoutConstraint!
    
    
    var currentWeather = CurrentWeather()
    var dailyWeather: [DailyWeather] = []
    //    var settingsVC = SettingsViewController()
    
    
    var zipCode : String = ""
    var exists: Bool = true
    
    var locationManager = CLLocationManager()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height  = dailyForecastCollectionView.collectionViewLayout.collectionViewContentSize.height
        collectionHeightConstraints.constant = height
        self.view.layoutIfNeeded()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherInformationDTOs = WeatherDataService.shared.listWeatherDataObject?.weatherInformationDTOs
        weatherDTO = weatherInformationDTOs?.first
        
        //location stuff
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
        
        dailyForecastCollectionView.delegate = self
        dailyForecastCollectionView.dataSource = self
        
        hourlyForecastCollectionView.delegate = self
        hourlyForecastCollectionView.dataSource = self
        
        hourlyForecastCollectionView.layer.borderColor = UIColor.darkGray.cgColor
        hourlyForecastCollectionView.layer.borderWidth = 0.25
        WeatherDataService.shared.update { (status) in
            self.getCurrentWeather()
        }
        configureMap()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func donebuttonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func settingbuttonClicked(_ sender: UIButton) {
        let webView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        webView.urlString = Constants.Urls.KHowtoStart
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
    @IBAction func mapbuttonClicked(_ sender: UIButton) {
        let mapView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.navigationController?.pushViewController(mapView, animated: true)
    }
    func configureMap(){
        let isDayTime = true
        if let weatherDTO = weatherDTO{
            conditionSymbolLabel.text = ConversionWorker.weatherConditionSymbol(
                fromWeatherCode: weatherDTO.weatherCondition[0].identifier,
                isDayTime: isDayTime
            )
            conditionNameLabel.text = weatherDTO.weatherCondition.first?.conditionName
            conditionDescriptionLabel.text = weatherDTO.weatherCondition.first?.conditionDescription?.capitalized
            
            if let temperatureKelvin = weatherDTO.atmosphericInformation.temperatureKelvin {
                let temperatureUnit = PreferencesDataService.shared.temperatureUnit
                temperatureLabel.text = ConversionWorker.temperatureDescriptor(forTemperatureUnit: temperatureUnit, fromRawTemperature: temperatureKelvin)
            } else {
                temperatureLabel.text = nil
            }
            timeLabel.text = getDate ()
            cloudCoverImageView.tintColor = .darkGray
            cloudCoverLabel.text = weatherDTO.cloudCoverage.coverage?.append(contentsOf: "%", delimiter: .none)
            humidityImageView.tintColor = .darkGray
            humidityLabel.text = weatherDTO.atmosphericInformation.humidity?.append(contentsOf: "%", delimiter: .none)
            pressureImageView.tintColor = .darkGray
            pressureLabel.text = weatherDTO.atmosphericInformation.pressurePsi?.append(contentsOf: "hpa", delimiter: .space)
            
            windSpeedImageView.tintColor = .darkGray
            
            if let windspeed = weatherDTO.windInformation.windspeed {
                windSpeedLabel.text = ConversionWorker.windspeedDescriptor(
                    forDistanceSpeedUnit: PreferencesDataService.shared.distanceSpeedUnit,
                    forWindspeed: windspeed
                )
            } else {
                windSpeedStackView.isHidden = true
            }
            
            if let windDirection = weatherDTO.windInformation.degrees {
                windDirectionImageView.transform = CGAffineTransform(rotationAngle: CGFloat(windDirection)*0.0174532925199) // convert to radians
                windDirectionImageView.tintColor = .darkGray
                windDirectionLabel.text = ConversionWorker.windDirectionDescriptor(forWindDirection: windDirection)
            } else {
                windDirectionStackView.isHidden = true
            }
        }
    }
    
    //gets TODAY'S date
    func getDate () -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayString: String = dateFormatter.string(from: date)
        print("Current date is \(dayString)")
        return dayString
        
    }
    
    //Gets next 6 days of week based on today
    func getDaysOfWeek () -> Array<String> {
        
        var daysOfWeekArray : [String] = ["", "","", "","", ""] //array has 6
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        for i in 1...6 {
            let nextDay = NSCalendar.current.date(byAdding: Calendar.Component.day,
                                                  value: i,
                                                  to: date as Date)
            dateFormatter.dateFormat = "EEEE"
            let dayString: String = dateFormatter.string(from: nextDay!)
            daysOfWeekArray[i-1] = dayString
        }
        
        return daysOfWeekArray
        
    }
    
    
    //Gets next 24 hours starting with current time
    func getHoursOfDay () -> Array<String> {
        
        var hoursOfDayArray : [String] = ["", "","", "","", "", "", "", "", "", "", "","", "","", "", "", "", "", "", "", "","", "", ""] //array has 25
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "h a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        for i in 1...25 {
            let nextDay = NSCalendar.current.date(byAdding: Calendar.Component.hour,
                                                  value: i-1,
                                                  to: date as Date)
            let dayString: String = dateFormatter.string(from: nextDay!)
            hoursOfDayArray[i-1] = dayString
        }
        
        return hoursOfDayArray
        
    }
    
    
    //User clicks edit button
    @IBAction func editBtnPressed(_ sender: Any) {
    }
    
    
    //Gets current weather data
    func getCurrentWeather() {
        
        guard weatherInformationDTOs != nil, !(weatherInformationDTOs?.isEmpty ?? false) else {
            return
        }
        let currentWeather = CurrentWeather()
        let dailyWeather = NSMutableArray()
        let hourlyWeather = NSMutableArray()
        for weatherDTO in weatherInformationDTOs!{
            if let temperatureKelvin = weatherDTO.atmosphericInformation.temperatureKelvin {
                currentWeather.currentTemp = temperatureKelvin
            }
            if let iconCode = weatherDTO.weatherCondition.first?.conditionIconCode {
                currentWeather.currentImg = UIImage (named: iconCode)
            }
            if let summary = weatherDTO.weatherCondition.first?.conditionName {
                currentWeather.currentCondition = summary
            }
            if let temperatureKelvin = weatherDTO.atmosphericInformation.tempHigh {
                currentWeather.high = temperatureKelvin
            }
            if let temperatureLow = weatherDTO.atmosphericInformation.tempLow {
                currentWeather.low = temperatureLow
            }
            // 'hour' object created
            let hour = HourlyWeather()
            
            if let dateString = weatherDTO.date {
                let dateOnly = dateString.components(separatedBy: " ")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let todayStr = dateFormatter.string(from: Date())
                let date = dateFormatter.date(from:dateOnly.first ?? todayStr)
                let todayDate = dateFormatter.date(from: todayStr)
                if date == todayDate{
                    if let temperatureKelvin = weatherDTO.atmosphericInformation.temperatureKelvin {
                        hour.temp = temperatureKelvin
                    }
                    if let iconCode = weatherDTO.weatherCondition.first?.identifier {
                        hour.conditionImg = iconCode
                    }
                    hourlyWeather.add(hour)
                }
            }
            
        }
        //    for i in 0...6{
        // 'day' object created
        let duplicateObjects = Dictionary(grouping: weatherInformationDTOs!, by: { $0.onlyDate })
        
        for weatherDTO in duplicateObjects{
            let day = DailyWeather()
            if let temperatureKelvin = weatherDTO.value.first?.atmosphericInformation.tempHigh {
                day.high = temperatureKelvin
            }
            if let temperatureLow = weatherDTO.value.first?.atmosphericInformation.tempLow {
                day.low = temperatureLow
            }
            if let iconCode = weatherDTO.value.first?.weatherCondition.first?.identifier {
                day.conditionImg =  iconCode
            }
            dailyWeather.add(day)
        }
        DispatchQueue.main.async {
            if self.exists{
                
                let isFah = (UserDefaults.standard.value(forKey: "chosenDegree") as? Int)
                
                self.currentHighLbl.isHidden = false
                self.currentLowLbl.isHidden = false
                
                if (isFah == 0) {
                    let roundedHigh = lround(currentWeather.high)
                    let roundedLow = lround(currentWeather.low)
                    
                    self.currentHighLbl.text = roundedHigh.description
                    self.currentLowLbl.text = roundedLow.description
                }
                
                
                else
                {
                    let roundedHighCelsius = lround(currentWeather.highCelsius)
                    let roundedLowCelsius = lround(currentWeather.lowCelsius)
                    
                    self.currentHighLbl.text = roundedHighCelsius.description
                    self.currentLowLbl.text = roundedLowCelsius.description
                }
                
                
                self.hourlyForecastCollectionView.reloadData()
                self.dailyForecastCollectionView.reloadData()
                
                
            } else{
                self.currentHighLbl.isHidden = true
                self.currentLowLbl.isHidden = true
                self.exists = true
                
            }
            self.currentWeather = currentWeather
            self.dailyWeather = dailyWeather as! [DailyWeather]
            self.currentWeather.hourlyWeather = hourlyWeather as! [HourlyWeather]
            
            
            print("dailyWeather Array size: \(self.dailyWeather.count)")
            print("hourlyWeather Array size: \(self.currentWeather.hourlyWeather.count)")
            
        }
        self.dailyForecastCollectionView.reloadData()
        self.hourlyForecastCollectionView.reloadData()
        
    }
    
    //Arrays
    lazy var daysOfWeekArray : [String] = getDaysOfWeek()
    lazy var hoursOfDayArray : [String] = getHoursOfDay()
    
    //Collection view count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.hourlyForecastCollectionView {
            print("CV test: \(currentWeather.hourlyWeather.count)")
            print("CV test: \(dailyWeather.count)")
            
            
            if (currentWeather.hourlyWeather.count) != 0 {
                return (currentWeather.hourlyWeather.count)
            }
            else {
                return 0
            }
            
        }
        else{
            
            if dailyWeather.count != 0 {
                return dailyWeather.count
            }
            else {
                return 0
            }
            
            
        }
        
    }
    
    //Formatting cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.hourlyForecastCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as! HourlyCollectionViewCell
            
            
            
            cell.hourLbl.text = "\(hoursOfDayArray[indexPath.row])"
            cell.hourImageLbl.text = ConversionWorker.weatherConditionSymbol(
                fromWeatherCode: self.currentWeather.hourlyWeather[indexPath.row].conditionImg,
                isDayTime: true
            )
            
            
            let isFah = (UserDefaults.standard.value(forKey: "chosenDegree") as? Int)
            if (isFah == 0) {
                let roundedDegree = lround(self.currentWeather.hourlyWeather[indexPath.row].temp)
                cell.hourDegreeLbl.text = "\(roundedDegree.description)˚"
            }
            else
            {
                let roundedDegreeCelsius = lround(self.currentWeather.hourlyWeather[indexPath.row].tempCelsius)
                cell.hourDegreeLbl.text = "\(roundedDegreeCelsius.description)˚c"
            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyCollectionViewCell", for: indexPath) as! DailyCollectionViewCell
            cell.dayImageLbl.text = ConversionWorker.weatherConditionSymbol(
                fromWeatherCode: self.dailyWeather[indexPath.row].conditionImg,
                isDayTime: true
            )
            cell.dayLbl.text = daysOfWeekArray[indexPath.row]
            let isFah = (UserDefaults.standard.value(forKey: "chosenDegree") as? Int)
            if (isFah == 0) {
                let roundedHigh = lround(self.dailyWeather[indexPath.row].high)
                cell.highLbl.text = "High \(roundedHigh.description)"
                let roundedLow = lround(self.dailyWeather[indexPath.row].low)
                cell.lowLbl.text = "Low \(roundedLow.description)"
            }
            else
            {
                let roundedHighCelsius = lround(self.dailyWeather[indexPath.row].highCelsius)
                cell.highLbl.text = "High \(roundedHighCelsius.description)"
                let roundedLowCelsius = lround(self.dailyWeather[indexPath.row].lowCelsius)
                cell.lowLbl.text = "Low \(roundedLowCelsius.description)"
            }
            
            
            return cell
            
        }
        
        
    }
}
