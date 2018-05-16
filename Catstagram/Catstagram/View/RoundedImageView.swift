
import UIKit

class RoundedImageView: UIView {
  private var _image: UIImage?
  
  var image: UIImage? {
    get {
      return _image
    }
    
    set {
      _image = newValue
      
      layer.contents = nil
      
      guard let image = newValue else { return }
      
      DispatchQueue.global(qos: .userInitiated).async {
        let roundImage = UIImage.circularImage(from: image, size: self.bounds.size)
        
        DispatchQueue.main.async {
          self.layer.contents = roundImage?.cgImage
        }
      }
    }
  }
}
