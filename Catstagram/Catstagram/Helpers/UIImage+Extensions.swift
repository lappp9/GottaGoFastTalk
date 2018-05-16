
import UIKit

extension UIImage {
  static let simpleImageCache = NSCache<NSURL, UIImage>()
  
  // Add circular image method here
  class func circularImage(from image: UIImage, size: CGSize) -> UIImage? {
    if let cachedImage = UIImage.globalRoundImageCache.object(forKey: image) as? UIImage {
      return cachedImage
    }
    
    let scale = UIScreen.main.scale
    let circleRect = CGRect(x: 0, y: 0, width: size.width * scale, height: size.height * scale)
    
    UIGraphicsBeginImageContextWithOptions(circleRect.size, false, scale)
    
    let circlePath = UIBezierPath(roundedRect: circleRect, cornerRadius: circleRect.size.width/2.0)
    circlePath.addClip()
    
    image.draw(in: circleRect)
    
    if let roundImage = UIGraphicsGetImageFromCurrentImageContext() {
      UIImage.globalRoundImageCache.setObject(roundImage, forKey: image)
      return roundImage
    }
    
    return nil
  }

  // Add JPEG drawing here
  class func decodedImage(_ image: UIImage) -> UIImage? {
    guard let newImage = image.cgImage else { return nil }
    if let cachedImage = UIImage.globalCache.object(forKey: image) as? UIImage {
      return cachedImage
    }

    let colorspace = CGColorSpaceCreateDeviceRGB()
    let context = CGContext(data: nil,
                            width: newImage.width,
                            height: newImage.height,
                            bitsPerComponent: 8,
                            bytesPerRow: newImage.width * 4,
                            space: colorspace,
                            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
    
    context?.draw(newImage, in: CGRect(x: 0, y: 0, width: newImage.width, height: newImage.height))
    let drawnImage = context?.makeImage()
    
    if let drawnImage = drawnImage {
      let decodedImage = UIImage(cgImage: drawnImage)
      UIImage.globalCache.setObject(decodedImage, forKey: image)
      return decodedImage
    }
    
    return nil
  }
  
  class func downloadImage(with url: URL?, completion: @escaping ((_ image: UIImage) -> Void)) {
    guard let url = url else { return }
    
    if let image = simpleImageCache.object(forKey: url as NSURL) {
      if Thread.isMainThread {
        completion(image)
      } else {
        DispatchQueue.main.async {
          completion(image)
        }
      }
    } else {
      let session = URLSession(configuration: .ephemeral)
      
      let task = session.dataTask(with: url, completionHandler: { (data, urlResponse, error) in
        if let data = data, let image = UIImage(data: data) {
          simpleImageCache.setObject(image, forKey: url as NSURL)
          DispatchQueue.main.async {
            completion(image)
          }
        }
      })
      
      task.resume()
    }
  }
}

// Add global NSCache here

extension UIImage {
  // 1)
  struct StaticCacheWrapper {
    static var cache = NSCache<AnyObject, AnyObject>()
    static var roundCache = NSCache<AnyObject, AnyObject>()
  }
  // 2)
  class var globalCache: NSCache<AnyObject, AnyObject> {
    get { return StaticCacheWrapper.cache }
    set { StaticCacheWrapper.cache = newValue }
  }
  // 3)
  class var globalRoundImageCache: NSCache<AnyObject, AnyObject> {
    get { return StaticCacheWrapper.roundCache }
    set { StaticCacheWrapper.roundCache = newValue }
  }
}

