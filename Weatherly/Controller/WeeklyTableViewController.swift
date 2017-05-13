
import UIKit

class WeeklyTableViewController: UITableViewController {
    
    @IBOutlet weak var currentTemperatureLabel: UILabel?
    @IBOutlet weak var currentWeatherIcon: UIImageView?
    @IBOutlet weak var currentPrecipitationLabel: UILabel?
    @IBOutlet weak var currentTemperatureRangeLabel: UILabel?
    
    // 座標の定数
    let coordinate: (lat: Double, lon: Double) = (32.7150, -117.1625)
    
    var weeklyWeather: [DailyWeather] = []
    
    //API key
    fileprivate let forecastAPIKey = "6fabee7c9bc65bf101f70e575d028b9e"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        retrieveWeatherForecast()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configureView(){
        // Set table view's background view property
        tableView.backgroundView = BackgroundView()
        
        // set custom height for the table view row
        tableView.rowHeight = 64
        
        // WeeklyTableViewControllerのフォントを変える
        if let buttonFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0){
            let barButtonAttributeDictionary: [String: AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: buttonFont
            ]
            
            UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributeDictionary, for: UIControlState())
            
        }
        
        // Position refresh Control above the background view
        refreshControl?.layer.zPosition = tableView.backgroundView!.layer.zPosition + 1
        refreshControl?.tintColor = UIColor.white
        
    }
    
    @IBAction func refreshWeather() {
        retrieveWeatherForecast()
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDaily"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let dailyWeather = weeklyWeather[indexPath.row]
                
                (segue.destination as! ViewController).dailyWeather =
                dailyWeather
            }
        }
    }
    
    // MARK: - Table view data source
    
    // displays the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerTitle = UILabel()
        headerTitle.text = "Forecast"
        
        return headerTitle
    }
    
    // displays the number of rows in the section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyWeather.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeueReusuableCellWithIdentifier - 引数の中に入れた名前のcellがちゃんと使えるかのメソッド
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! DailyWeatherTableViewCell
        
        let dailyWeather = weeklyWeather[indexPath.row]
        if let maxTemperature = dailyWeather.maxTemperature{
            cell.temperatureLabel.text = "\(maxTemperature)º"
        }
        
        cell.weatherIcon.image = dailyWeather.icon
        cell.dayLabel.text = dailyWeather.day
        
        return cell
    }
    
    // MARK: - Delegate Methods
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.backgroundColor = UIColor(red: 170/255.0, green: 131/255.0, blue: 224/255.0, alpha: 1.0)
    
        
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor(red: 165/255.0, green: 142/255.0, blue: 203/255.0, alpha: 1.0)
        let highlightView = UIView()
        highlightView.backgroundColor = UIColor(red: 165/255.0, green: 142/255.0, blue: 203/255.0, alpha: 1.0)
        cell?.selectedBackgroundView = highlightView
    }
    
    // MARK: - Weather Fetching
    
    func retrieveWeatherForecast() {
        let forecastService = ForecastService(APIKey: forecastAPIKey)
        forecastService.getForecast(coordinate.lat, lon: coordinate.lon) {
            (forecast) in
            
            if let weatherForecast = forecast,
                let currentWeather = weatherForecast.currentWeather{
                    
                    DispatchQueue.main.async {
                        
                        if let temperature = currentWeather.temperature {
                            self.currentTemperatureLabel?.text = "\(temperature)º"
                        }
                        
                        /*if let humidity = currentWeather.humidity {
                        self.currentHumidityLabel?.text = "\(humidity)%"
                        } */
                        
                        if let precipitation = currentWeather.precipProbability {
                            self.currentPrecipitationLabel?.text = "Rain: \(precipitation)%"
                        }
                        
                        if let icon = currentWeather.icon {
                            self.currentWeatherIcon?.image = icon
                        }
                        
                        self.weeklyWeather = weatherForecast.weekly
                        
                        if let highTemperature = self.weeklyWeather.first?.maxTemperature,
                            let lowTemperature = self.weeklyWeather.first?.minTemperature{
                                self.currentTemperatureRangeLabel?.text = "↑\(highTemperature)º↓\(lowTemperature)º"
                        }
                        
                        self.tableView.reloadData()
                        
                    } // dispatch_async(dispatch_get_main_queue())
                    
            } //UnWrapping weatherForecast
            
        } // UnWrapping forecastService
        
    }// retrieveWeatherForecast()
    
} // class
