
import UIKit

class ViewController: UIViewController {

    // 天気のアイコン
    @IBOutlet weak var weatherIcon: UIImageView?
    // 天気の要約
    @IBOutlet weak var summaryLabel: UILabel?
    //　日が昇る時間
    @IBOutlet weak var sunriseTimeLabel: UILabel?
    // 日が沈む時間
    @IBOutlet weak var sunsetTimeLabel: UILabel?
    //  最低気温
    @IBOutlet weak var lowTemperatureLabel: UILabel?
    // 最高気温
    @IBOutlet weak var highTemperatureLabel: UILabel?
    // 降水確率
    @IBOutlet weak var precipitationLabel: UILabel?
    // 湿度
    @IBOutlet weak var humidityLabel: UILabel?
    
    var dailyWeather: DailyWeather? {
        didSet{
            configureView()
        }
    }
    
    func configureView(){
        if let weather = dailyWeather{
            weatherIcon?.image = weather.largeIcon
            summaryLabel?.text = weather.summary
            sunriseTimeLabel?.text = weather.sunriseTime
            sunsetTimeLabel?.text = weather.sunsetTime
            
            
            if let lowTemp = weather.minTemperature {
                lowTemperatureLabel?.text = "\(lowTemp)º"
            } else {
                lowTemperatureLabel?.text = "N/A"
            }
            
            if let highTemp = weather.maxTemperature {
                highTemperatureLabel?.text = "\(highTemp)º"
            } else {
                highTemperatureLabel?.text = "N/A"
            }
            
            if let rain = weather.precipChance {
                precipitationLabel?.text = "\(rain)%"
            } else {
                precipitationLabel?.text = "N/A"
            }
            
            if let humidity = weather.humidity {
                humidityLabel?.text = "\(humidity)%"
            } else {
                humidityLabel?.text = "N/A"
            }
        
            self.title = weather.day
        }
        
        // configure nav bar back button
        if let buttonFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0){
            let navBarAttributeDictionary: [String: AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: buttonFont
            ]
            
            navigationController?.navigationBar.titleTextAttributes = navBarAttributeDictionary
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*retrieveWeatherForecast()*/
        
        configureView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

