
// 天気の情報を入れた構造体

import UIKit
import Foundation

struct DailyWeather{
    
    let maxTemperature: Int?
    let minTemperature: Int?
    let humidity: Int?
    let precipChance: Int?
    let summary: String?
    
    var icon: UIImage? = UIImage(named: "default.png")
    var largeIcon: UIImage? = UIImage(named: "default.png")
    
    var sunriseTime: String?
    var sunsetTime: String?
    var day: String?
    let dateFormatter = NSDateFormatter()
    
    // いろいろな型をいれるので、anyobjectで
    // as? はoptionalが入るかもなので
    init(dailyWeatherDict: [String: AnyObject]) {
        maxTemperature = dailyWeatherDict["temperatureMax"] as? Int
        minTemperature = dailyWeatherDict["temperatureMix"] as? Int
        
        if let humidityFloat = dailyWeatherDict["humidity"] as? Double{
            humidity = Int(humidityFloat * 100)
        } else {
            humidity = nil
        }
        
        if let precipChanceFloat = dailyWeatherDict["precipProbability"] as? Double{
            precipChance = Int(precipChanceFloat * 100)
        } else{
            precipChance = nil
        }
        
        summary = dailyWeatherDict["summary"] as? String
        
        if let iconString = dailyWeatherDict["icon"] as? String,
            let iconEnum = Icon(rawValue: iconString){
                (icon, largeIcon) = iconEnum.toImage()
        }
        
        if let sunriseDate = dailyWeatherDict["sunriseTime"] as? Double {
            sunriseTime = timeStringFromUnixTime(sunriseDate)
        } else{
            sunriseTime = nil
        }
        
        if let sunsetDate = dailyWeatherDict["sunsetTime"] as? Double{
            sunsetTime = timeStringFromUnixTime(sunsetDate)
        } else{
            sunsetTime = nil
        }
        
        if let time = dailyWeatherDict["time"] as? Double{
            day = dayStingFromTime(time)
        }
    }
    
    // 時間変換メソッド
    func timeStringFromUnixTime(unixTime: Double) -> String{
        let date = NSDate(timeIntervalSince1970: unixTime)
        
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.stringFromDate(date)
    }
    
    // 時間から日に変える変換メソッド
    func dayStingFromTime(time: Double) -> String {
        let date = NSDate(timeIntervalSince1970: time)
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.stringFromDate(date)
    }
}




