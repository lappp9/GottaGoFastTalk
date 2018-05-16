
import Foundation

class User : Decodable {
  enum CodingKeys : String, CodingKey {
    case avatarURL = "userpic_url"
    case username
  }
  
  let username: String
  let avatarURL: URL
  
  func usernameAttributedString(withFontSize fontSize: CGFloat) -> NSAttributedString {
    return NSAttributedString(string: username, fontSize: fontSize, color: UIColor.darkBlue(), firstWordColor: nil)
  }
}
