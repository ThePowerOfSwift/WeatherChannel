
// APIからデータをダウンロードするファイル

import Foundation

struct ForecastService {
    
    let forecastAPIKey: String
    let forecastBaseURL: NSURL?
    
    init(APIKey: String) {
        forecastAPIKey = APIKey
        forecastBaseURL = NSURL(string: "https://api.forecast.io/forecast/\(forecastAPIKey)/")
    }
    
    func getForecast(lat: Double, lon: Double, completion: (Forecast? -> Void)) {
        // forrecastURLはoptinal定数なので、ここでwrapする必要がある
        if let forecastURL = NSURL(string: "\(lat),\(lon)", relativeToURL: forecastBaseURL) {
            //NetworkOperationファイルのインスタンス
            let networkOperation = NetworkOperation(url: forecastURL)
            
            
            networkOperation.downloadJSONFromURL {
                // typealias型をつかったので、このような書き方
                (let JSONDictionary) in
                let forecast = Forecast(weatherDictionary: JSONDictionary)
                completion(forecast)
            }
        } else {
            print("Could not construct a valid URL")
        }
    }
    
    
}