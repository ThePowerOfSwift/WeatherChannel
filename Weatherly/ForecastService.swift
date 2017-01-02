
// APIからデータをダウンロードするファイル

import Foundation

struct ForecastService {
    
    let forecastAPIKey: String
    let forecastBaseURL: URL?
    
    init(APIKey: String) {
        forecastAPIKey = APIKey
        forecastBaseURL = URL(string: "https://api.forecast.io/forecast/\(forecastAPIKey)/")
    }
    
    func getForecast(_ lat: Double, lon: Double, completion: @escaping ((Forecast?) -> Void)) {
        // forrecastURLはoptinal定数なので、ここでwrapする必要がある
        if let forecastURL = URL(string: "\(lat),\(lon)", relativeTo: forecastBaseURL) {
            //NetworkOperationファイルのインスタンス
            let networkOperation = NetworkOperation(url: forecastURL)
            
            
            networkOperation.downloadJSONFromURL {
                // typealias型をつかったので、このような書き方
                (JSONDictionary) in
                let forecast = Forecast(weatherDictionary: JSONDictionary)
                completion(forecast)
            }
        } else {
            print("Could not construct a valid URL")
        }
    }
    
    
}
