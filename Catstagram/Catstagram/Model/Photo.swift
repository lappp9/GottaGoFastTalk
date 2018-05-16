
import Foundation

class Photo : Decodable {
  enum CodingKeys : String, CodingKey {
    case urls = "image_url"
    case uploadDateString = "created_at"
    case descriptionText = "name"
    case commentsCount = "comments_count"
    case likesCount = "positive_votes_count"
    case user
  }
  
  let urls: [URL]
  let uploadDateString: Date
  let descriptionText: String
  let commentsCount: UInt
  let likesCount: UInt

  let user: User
  
  func descriptionAttributedString(withFontSize size: CGFloat) -> NSAttributedString {
    return NSAttributedString(string: "\(user.username) \(descriptionText)", fontSize: CGFloat(size), color: UIColor.darkGray, firstWordColor: UIColor.darkBlue())
  }

  func uploadDateAttributedString(withFontSize size: Float) -> NSAttributedString {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    let string = formatter.string(from: uploadDateString)
    return NSAttributedString(string: string, fontSize: CGFloat(size), color: UIColor.lightGray, firstWordColor: nil)
  }

  func likesAttributedString(withFontSize size: Float) -> NSAttributedString {
    return NSAttributedString(string: "\(likesCount) likes", fontSize: CGFloat(size), color: UIColor.darkBlue(), firstWordColor: nil)
  }

  static func ==(lhs: Photo, rhs: Photo) -> Bool {
    return lhs.urls == rhs.urls &&
    lhs.uploadDateString == rhs.uploadDateString &&
    lhs.descriptionText == rhs.descriptionText &&
    lhs.commentsCount == rhs.commentsCount &&
    lhs.likesCount == rhs.likesCount
  }
}
