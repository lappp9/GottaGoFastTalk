
import UIKit

class LikersView: UIView {
  let firstLikeImageView = RoundedImageView()
  let secondLikeImageView = RoundedImageView()
  let thirdLikeImageView = RoundedImageView()

  init() {
    super.init(frame: .zero)
    
    addSubview(firstLikeImageView)
    addSubview(secondLikeImageView)
    addSubview(thirdLikeImageView)

    reloadLikers()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let likerViews = [firstLikeImageView, secondLikeImageView, thirdLikeImageView]

    var i: CGFloat = 1.0
    for likerView in likerViews {
      likerView.backgroundColor = .lightGray
      
      layout(likerView: likerView, at: i)
      i += 2
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK - Helpers

extension LikersView {
  func layout(likerView: UIView, at position: CGFloat) {
    // we want 1/6 -- 3/6 ---5/6
    let center = CGPoint(x: ((position/6.0) * self.bounds.width), y: self.bounds.height/2.0)
    likerView.bounds = CGRect(x: 0, y: 0, width: 25, height: 25)
    likerView.center = center
    likerView.clipsToBounds = true
  }
  
  func reloadLikers() {
    let imageViews = [firstLikeImageView, secondLikeImageView, thirdLikeImageView]
    let urls = randomSetOfURLs()
    for imageView in imageViews {
      imageView.layer.contents = nil
      let i = imageViews.index(of: imageView)!
      let url = URL(string: urls[i])
      
      UIImage.downloadImage(with: url, completion: { (image) in
        imageView.image = image
      })
    }
  }
  
  func randomSetOfURLs() -> [String] {
    let index = Int(arc4random_uniform(3))
    let urls = [["https://images.unsplash.com/photo-1513103891413-5cd7019648f2?ixlib=rb-0.3.5&s=9fff335ee6807afc44080fd873806266&auto=format&fit=crop&w=2468&q=80",
                 "https://images.unsplash.com/photo-1514866747592-c2d279258a78?ixlib=rb-0.3.5&s=02fbc5840dfebd4bea9a35029ff1942d&auto=format&fit=crop&w=800&q=60",
                 "https://images.unsplash.com/photo-1476505312917-7d02cbf00c0d?ixlib=rb-0.3.5&s=f80926cf22a9821d6b22979ce9d3155d&auto=format&fit=crop&w=2550&q=80"],
                ["https://images.unsplash.com/photo-1498558263790-a9555e3d002d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=0b4f47b3d1eb96a6d5948bcdfbb32de1&auto=format&fit=crop&w=1500&q=80",
                 "https://images.unsplash.com/photo-1504241579298-1075e9e114e5?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=ebf225d0bc77edb19fe00a14ed3ec34d&auto=format&fit=crop&w=2557&q=80",
                 "https://images.unsplash.com/photo-1504575070132-986227df99f7?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=1bd11763a76e8d8de994bea06995e2a5&auto=format&fit=crop&w=668&q=80"],
                ["https://images.unsplash.com/photo-1489278353717-f64c6ee8a4d2?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=74573ba50aaf28e009bb77bee78fc350&auto=format&fit=crop&w=1500&q=80",
                 "https://images.unsplash.com/photo-1496595351388-d74ec2c9c9cc?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=51ec679cef41e98d188b55fc4256d1d8&auto=format&fit=crop&w=1528&q=80",
                 "https://images.unsplash.com/photo-1513270246933-7a934b770ea6?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=dc2fb1c879c1c5bdc6f244dde7fc7f80&auto=format&fit=crop&w=1500&q=80"]
    ]
    
    return urls[index]
  }
}
