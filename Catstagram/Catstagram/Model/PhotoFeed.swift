
import Foundation

struct PhotoFeed : Decodable {
  let current_page: UInt
  let total_pages: UInt
  let total_items: UInt
  
  let photos: [Photo]
}
