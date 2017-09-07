
import UIKit

class CatPhotoTableViewCell: UITableViewCell {
    let userImageHeight:CGFloat = 30
    
    var photoModel: PhotoModel? = nil
    
    var userAvatarImageView = UIImageView()
    var photoImageView = UIImageView()
    
    var userNameLabel = UILabel()
    var photoTimeIntervalSincePostLabel = UILabel()
    var photoLikesLabel = UILabel()

    var photoDescriptionContainer = UIView()
    
    var photoDescriptionLabel1 = UILabel()
    var photoDescriptionLabel2 = UILabel()
    var photoDescriptionLabel3 = UILabel()

    var userNameYPositionWithoutPhotoLocation = NSLayoutConstraint()
    var photoLocationYPosition = NSLayoutConstraint()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    //MARK: Motion
    func panImage(with yRotation: CGFloat) {
        let lowerLimit = bounds.size.width/2 - 10
        let upperLimit = bounds.size.width/2 + 10
        let rotationMult: CGFloat = 5.0
        
        var possibleXOffset = photoImageView.center.x + ((yRotation * -1) * rotationMult * 1)
        
        possibleXOffset = (possibleXOffset < lowerLimit) ? lowerLimit : possibleXOffset
        possibleXOffset = (possibleXOffset > upperLimit) ? upperLimit : possibleXOffset
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.beginFromCurrentState, .allowUserInteraction, .curveEaseOut], animations: {
            self.photoImageView.center = CGPoint(x: possibleXOffset, y: self.photoImageView.center.y)
        }, completion: nil)
    }
    
    //MARK: Setup
    func downloadAndProcessUserAvatar(forPhoto photoModel: PhotoModel) {
        UIImage.downloadImage(for: photoModel.url) { (image) in
            if self.photoModel == photoModel {
                if let size = image?.size {
                    self.userAvatarImageView.image = image //?.makeCircularImage(with: size)
                }
            }
        }
    }
    
    func setupViews() {
        addSubview(userAvatarImageView)
        addSubview(photoImageView)
        addSubview(userNameLabel)
        addSubview(photoTimeIntervalSincePostLabel)
        addSubview(photoLikesLabel)
        
        photoDescriptionContainer.addSubview(photoDescriptionLabel1)
        photoDescriptionContainer.addSubview(photoDescriptionLabel2)
        photoDescriptionContainer.addSubview(photoDescriptionLabel3)
        addSubview(photoDescriptionContainer)
        
        userAvatarImageView.backgroundColor = UIColor.lightGray
        photoImageView.backgroundColor = UIColor.lightGray
        photoImageView.clipsToBounds = true
        photoImageView.contentMode = .scaleAspectFill
        
        userAvatarImageView.layer.cornerRadius = userImageHeight/2.0
        userAvatarImageView.clipsToBounds = true
        
        userAvatarImageView.translatesAutoresizingMaskIntoConstraints             = false
        photoImageView.translatesAutoresizingMaskIntoConstraints                  = false
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints                   = false
        photoTimeIntervalSincePostLabel.translatesAutoresizingMaskIntoConstraints = false
        photoLikesLabel.translatesAutoresizingMaskIntoConstraints                 = false
        
        setupConstraints()
        updateConstraints()
    }
    
    //MARK: Cell Reuse
    func updateCell(with photo: PhotoModel?) {
        photoModel = photo
        
        guard let photoModel = photoModel else { return }
        
        userNameLabel.attributedText = photoModel.ownerUserProfile?.usernameAttributedString(withFontSize: 14.0)
        photoTimeIntervalSincePostLabel.attributedText = photoModel.uploadDateAttributedString(withFontSize: 14.0)
        photoLikesLabel.attributedText = photoModel.likesAttributedString(withFontSize: 14.0)
        
        photoDescriptionLabel1.attributedText = photoModel.descriptionAttributedString(withFontSize: 14.0)
        photoDescriptionLabel2.attributedText = photoModel.descriptionAttributedString(withFontSize: 14.0)
        photoDescriptionLabel3.attributedText = photoModel.descriptionAttributedString(withFontSize: 14.0)
        
        photoDescriptionLabel1.numberOfLines = 0
        photoDescriptionLabel2.numberOfLines = 0
        photoDescriptionLabel3.numberOfLines = 0
        
//        //Wowza
        photoDescriptionContainer.layer.shouldRasterize = true
        photoDescriptionLabel1.layer.shouldRasterize = true
        photoDescriptionLabel2.layer.shouldRasterize = true
        photoDescriptionLabel3.layer.shouldRasterize = true
        photoImageView.layer.shouldRasterize = true
        userNameLabel.layer.shouldRasterize = true
        
        photoDescriptionLabel1.layer.opacity = 1.0

        userNameLabel.sizeToFit()
        photoTimeIntervalSincePostLabel.sizeToFit()
        photoLikesLabel.sizeToFit()
        
        UIImage.downloadImage(for: photoModel.url) { (image) in
            if self.photoModel == photo {
//                self.photoImageView.image = image
            }
        }
        downloadAndProcessUserAvatar(forPhoto: photoModel)
    }
    
    override func prepareForReuse() {
        clearImages()
        
        userNameLabel.attributedText                   = nil
        photoTimeIntervalSincePostLabel.attributedText = nil
        photoLikesLabel.attributedText                 = nil
        photoDescriptionLabel1.attributedText           = nil
        photoDescriptionLabel2.attributedText           = nil
        photoDescriptionLabel3.attributedText           = nil
    }
    
    func clearImages() {
        userAvatarImageView.layer.contents = nil
        photoImageView.layer.contents = nil
        
        userAvatarImageView.image                      = UIImage(named: "placeholder")
        photoImageView.image                           = UIImage(named: "placeholder")
    }
    
    //MARK: Obligatory init you don't use.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
