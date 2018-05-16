
import Foundation

class PhotoFeedManager {
  private let numCommentsToShow = 3
  private let fiveHundredPXBaseURL = "https://api.500px.com/v1/"
  private let fiveHundredPXPhotosURI = "photos/search?term=cat&exclude=Nude,People,Fashion&sort=rating&image_size=3&include_store=store_download&include_states=voted"
  
  // PLEASE REQUEST YOUR OWN 500PX CONSUMER KEY
  private let fiveHundredPXConsuemerKeyParam = "&consumer_key=IM9eKT7fZZc7gjJXrnXVgZlBUFLXeDpkRuH0MeNy"
  
  private var imageSize: CGSize
  private var photos = [Photo]()
  private var urlString: String
  
  private var currentPage: UInt = 0
  private var totalPages: UInt = 0
  private var totalItems: UInt = 0
  
  private var hasLoaded = false
  private var fetchPageInProgress = false
  private var refreshFeedInProgress = false
  private var task = URLSessionDataTask()
  
  init(imageSize: CGSize) {
    self.imageSize = imageSize
    self.urlString = fiveHundredPXBaseURL + fiveHundredPXPhotosURI + fiveHundredPXConsuemerKeyParam
  }
  
  func numberOfItemsInFeed() -> Int {
    return photos.count
  }
  
  func object(at index: Int) -> Photo {
    return photos[index]
  }
  
  func requestPage(with resultCount: UInt, completion: @escaping (([Photo]) -> Void)) {
    guard !fetchPageInProgress else { return }
    
    fetchPageInProgress = true
    fetchPage(with: resultCount, replacingData: false, completion: completion)
  }
  
  func refreshFeed(with resultCount: UInt, completion: @escaping (([Photo]) -> Void)) {
    guard !refreshFeedInProgress else { return }
    
    refreshFeedInProgress = true
    currentPage = 0
    fetchPage(with: resultCount, replacingData:true) { (results) in
      completion(results)
      self.refreshFeedInProgress = false
    }
  }
  
  //MARK: Helpers
  private func fetchPage(with resultCount: UInt, replacingData: Bool, completion: @escaping (([Photo]) -> Void)) {
    if hasLoaded {
      guard currentPage != totalPages else {
        completion([])
        return
      }
    }
    
    DispatchQueue.global(qos: .default).async {
      var newPhotos = [Photo]()
      
      let nextPage = self.currentPage + 1
      let urlAdditions = "&page=\(nextPage)&rpp=\(resultCount)&image_size=4"
      let url = URL(string: self.urlString + urlAdditions)
      let session = URLSession(configuration: .ephemeral)
      
      self.task = session.dataTask(with: url!, completionHandler: { (data, response, error) in
        guard let data = data else { return }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let feed = try! decoder.decode(PhotoFeed.self, from: data)
        self.currentPage = feed.current_page
        self.totalPages = feed.total_pages
        self.totalItems = feed.total_items
        
        for photo in feed.photos {
          newPhotos.append(photo)
        }
        DispatchQueue.main.async {
          if replacingData {
            self.photos = newPhotos
          } else {
            self.photos.append(contentsOf: newPhotos)
          }
          completion(newPhotos)
          self.hasLoaded = true
          self.fetchPageInProgress = false
        }
      })
      self.task.resume()
    }
  }
}

