
// JSONファイルをダウンロードするためのファイル

import Foundation

class NetworkOperation {
    
    // lazy variable - defers the initialization of an object right until we need it
    // 実際にその値が参照されるまでは生成されないようになる
    // 必要とされたときに値を初めて決定するから、コストカットになる
    
    // NSURLSessionConfiguration - ネットからデータをアップロードしたり、ダウンロードしたりするときに必要なクラス
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    let queryURL: NSURL
    
    // a typealias allows you to give an alternative name for a type in your program.
    // ([String: AnyObject]? -> Void)を入力するは手間かかるので、こうしてJSONDictionaryCompletionという名前をつけている。
    typealias JSONDictionaryCompletion = ([String: AnyObject]? -> Void)
    
    //urlの初期化
    init(url: NSURL) {
        self.queryURL = url
    }
    
    func downloadJSONFromURL(completion: JSONDictionaryCompletion) {
        
        let request = NSURLRequest(URL: queryURL)
        // dataTaskWithRequest - Creates a task that retrieves the contents of a URL based on the specified URL request object, and calls a handler upon completion.
        let dataTask = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            // 1. Check HTTP response for successful GET request
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    // 2. Create JSON object with data
                    let jsonDictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: [])) as? [String: AnyObject]
                    completion(jsonDictionary)
                default:
                    print("GET request not successful. HTTP status code: \(httpResponse.statusCode)")
                }
            } else {
                print("Error: Not a valid HTTP response")
            }
        }
        dataTask.resume()
    }
}