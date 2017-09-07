//
//  PhotoFeedModel.swift
//  Catstagram-Starter
//
//  Created by Luke Parham on 2/13/17.
//  Copyright © 2017 Luke Parham. All rights reserved.
//

import Foundation

class PhotoFeedModel {
    private let numCommentsToShow = 3
    private let fiveHundredPXBaseURL = "https://api.500px.com/v1/"
    private let fiveHundredPXPhotosURI = "photos/search?term=cat&exclude=Nude,People,Fashion&sort=rating&image_size=3&include_store=store_download&include_states=voted"

    // PLEASE REQUEST YOUR OWN 500PX CONSUMER KEY
    private let fiveHundredPXConsuemerKeyParam = "&consumer_key=IM9eKT7fZZc7gjJXrnXVgZlBUFLXeDpkRuH0MeNy"

    private var imageSize: CGSize
    private var photos = [PhotoModel]()
    private var ids = [Int]()
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
    
    func object(at index: Int) -> PhotoModel {
        return photos[index]
    }

    func index(of photoModel: PhotoModel) -> Int {
        return photos.index(of: photoModel)!
    }

    func clearFeed() {
        photos = [PhotoModel]()
        ids = [Int]()
        
        currentPage = 0
        fetchPageInProgress = false
        refreshFeedInProgress = false
        task.cancel()
        task = URLSessionDataTask()
    }
    
    func requestPage(with resultCount: UInt, completion: @escaping (([PhotoModel]) -> Void)) {
        guard !fetchPageInProgress else { return }
    
        fetchPageInProgress = true
        fetchPage(with: resultCount, replacingData: false, completion: completion)
    }

    func refreshFeed(with resultCount: UInt, completion: @escaping (([PhotoModel]) -> Void)) {
        guard !refreshFeedInProgress else { return }
        
        refreshFeedInProgress = true
        currentPage = 0
        fetchPage(with: resultCount, replacingData:true) { (results) in
            completion(results)
            self.refreshFeedInProgress = false
        }
    }
    
    //MARK: Helpers
    private func fetchPage(with resultCount: UInt, replacingData: Bool, completion: @escaping (([PhotoModel]) -> Void)) {
        if hasLoaded {
            guard currentPage != totalPages else {
                completion([])
                return
            }
        }
        
        DispatchQueue.global(qos: .default).async {
            var newPhotos = [PhotoModel]()
            var newIDs    = [Int]()
            
            let nextPage = self.currentPage + 1
            let urlAdditions = "&page=\(nextPage)&rpp=\(resultCount)&image_size=4"
            let url = URL(string: self.urlString + urlAdditions)
            let session = URLSession(configuration: .ephemeral)
            
            self.task = session.dataTask(with: url!, completionHandler: { (data, response, error) in
                guard let data = data else { return }
                
                let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
                if let json = json {
                    self.currentPage = json["current_page"] as! UInt
                    self.totalPages = json["total_pages"] as! UInt
                    self.totalItems = json["total_items"] as! UInt
                    
                    let photos = json["photos"] as! [[String: Any]]
                    for photoDictionary in photos {
                        let photo = PhotoModel(photoDictionary: photoDictionary)

                        if replacingData || !self.ids.contains(photo.photoID!) {
                            newPhotos.append(photo)
                            newIDs.append(photo.photoID!)
                        }
                    }
                }
                DispatchQueue.main.async {
                    if replacingData {
                        self.photos = newPhotos
                        self.ids = newIDs
                    } else {
                        self.photos.append(contentsOf: newPhotos)
                        self.ids.append(contentsOf: newIDs)
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
