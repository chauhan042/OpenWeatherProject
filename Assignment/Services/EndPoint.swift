//
//  EndPoint.swift
//  Assignment
//
//  Created by Nitin Singh on 11/02/21.
//

import Foundation
import UIKit

class CurrentWeather: NSObject {
    
    var currentTemp : Double!
    {
        didSet {
            tempCelsius = ((currentTemp - 32) * (5/9))
        }
    }
    var tempCelsius : Double!
    
    var currentImg : UIImage?
    var currentCondition : String!
    var location : String = ""       //not found in JSON
    var high : Double!
    {
        didSet {
            highCelsius = ((high - 32) * (5/9))
        }
    }
    var highCelsius : Double!
    var low : Double!
    {
        didSet {
            lowCelsius = ((low - 32) * (5/9))
        }
    }
    var lowCelsius : Double!
    var today : String!
    
    var hourlyWeather: [HourlyWeather] = []

    
    convenience init (currentTemp: Double, currentImg: UIImage, currentCondition: String, location: String, high: Double, low: Double, today: String, lowCelsius: Double, highCelsius: Double, tempCelsius: Double) {
        
        self.init()
        
        self.currentTemp = currentTemp
        self.currentImg = currentImg
        self.currentCondition = currentCondition
        self.location = location
        
        self.high = high
        self.low = low
        self.today = today
        
        self.lowCelsius = lowCelsius
        self.highCelsius = highCelsius
        self.tempCelsius = tempCelsius
        
    }

    
}


class DailyWeather: NSObject {
    
    var conditionImg : Int?
    var high : Double!
    {
        didSet {
            highCelsius = ((high - 32) * (5/9))
        }
    }
    var low : Double!
    {
        didSet {
            lowCelsius = ((low - 32) * (5/9))
        }
    }
    var lowCelsius: Double!
    var highCelsius: Double!
    var dayOfWeek : String!  //not found in JSON
    
    convenience init (conditionImg: Int, high: Double, low: Double, dayOfWeek: String, lowCelsius: Double, highCelsius: Double) {
        self.init()
        
        self.conditionImg = conditionImg
        self.high = high
        self.low = low
        self.dayOfWeek = dayOfWeek
        self.lowCelsius = lowCelsius
        self.highCelsius = highCelsius
        
    }
    
    
}



class HourlyWeather: NSObject {
    
    var temp : Double!
    {
        didSet {
            tempCelsius = ((temp - 32) * (5/9))
        }
    }
    var tempCelsius : Double!
    var conditionImg : Int?
    var hour : Int! //not found in JSON

    
    
    convenience init (temp: Double, conditionImg: Int, hour: Int, tempCelsius: Double) {
        self.init()
        
        self.temp = temp
        self.conditionImg = conditionImg
        self.hour = hour
        self.tempCelsius = tempCelsius

        
    }
    
    
    
}

