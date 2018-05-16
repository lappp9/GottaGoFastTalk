
import UIKit
import CoreLocation

class CatLogger: NSObject {
  let locationManager = CLLocationManager()
  
  func startLogging() {
    let timer = Timer(timeInterval: 0.1, target: self, selector: #selector(CatLogger.reportLogs), userInfo: nil, repeats: true)
    RunLoop.main.add(timer, forMode: .commonModes)
  }
  
  @objc func reportLogs() {
    let headers = [
      "cookie": "foo=bar; bar=baz",
      "accept": "application/json",
      "content-type": "application/x-www-form-urlencoded"
    ]
    
    crunchSomeNumbers()
    
    var postData = "foo=bar".data(using: String.Encoding.utf8)!
    postData.append("&bar=baz".data(using: String.Encoding.utf8)!)
    
    var request = URLRequest(
      url: URL(string: "https://mockbin.org/bin/d7fc711e-dc00-4a53-93e2-870a35163685?foo=bar&foo=baz")!,
      cachePolicy: .reloadIgnoringLocalCacheData,
      timeoutInterval: 10)
    
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    let configuration = URLSessionConfiguration.default
    let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: .main)
    let dataTask = session.dataTask(with: request) { (data, response, error) in
      
    }
    dataTask.resume()
  }
  
  func crunchSomeNumbers() {
    //stop judging me.
    var now = CACurrentMediaTime()
    let pointOneSecondsLater = now + 0.1
    var a = 0
    while now < pointOneSecondsLater {
      a += 1
      now = CACurrentMediaTime()
    }
  }
}
