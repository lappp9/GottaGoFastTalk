
import UIKit

extension CatPhotoTableViewCell {
  func setupConstraints() {
    addConstraintsForAvatar()
    addConstraintsForUserNameLabel()
    addConstraintsForPhotoTimeIntervalSincePostLabel()
    addConstraintsForPhotoImageView()
    addConstraintsForLikesLabel()
    addConstraintsForDescriptionLabel()
  }
  
  func addConstraintsForAvatar() {
    let horizontalBuffer:CGFloat = 8.0
    
    userAvatarImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: horizontalBuffer).isActive = true
    userAvatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: horizontalBuffer).isActive = true

    userAvatarImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    userAvatarImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
  }
  
  func addConstraintsForUserNameLabel() {
    let horizontalBuffer:CGFloat = 10.0

    userNameLabel.leftAnchor.constraint(equalTo: userAvatarImageView.rightAnchor, constant: horizontalBuffer).isActive = true
    userNameLabel.rightAnchor.constraint(lessThanOrEqualTo: photoTimeIntervalSincePostLabel.leftAnchor).isActive = true
    
    userNameLabel.centerYAnchor.constraint(equalTo: userAvatarImageView.centerYAnchor, constant: 1.0).isActive = true
  }
  
  func addConstraintsForPhotoTimeIntervalSincePostLabel() {
    let horizontalBuffer:CGFloat = 10.0

    photoTimeIntervalSincePostLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -horizontalBuffer).isActive = true
    photoTimeIntervalSincePostLabel.centerYAnchor.constraint(equalTo: userAvatarImageView.centerYAnchor, constant: 1.0).isActive = true
  }
  
  func addConstraintsForPhotoImageView() {
    let headerHeight:CGFloat = 50.0
    
    photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: headerHeight).isActive = true
    photoImageView.widthAnchor.constraint(equalTo: widthAnchor, constant: 1.1).isActive = true
    photoImageView.heightAnchor.constraint(equalTo: widthAnchor, constant: 1.0).isActive = true
  }
  
  func addConstraintsForLikesLabel() {
    let verticalBuffer:CGFloat = 5.0
    let horizontalBuffer:CGFloat = 10.0
    
    photoLikesLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: verticalBuffer).isActive = true
    photoLikesLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: horizontalBuffer).isActive = true
  }
  
  func addConstraintsForDescriptionLabel() {
    let verticalBuffer:CGFloat = 5.0
    let horizontalBuffer:CGFloat = 10.0

    
    photoDescriptionLabel.topAnchor.constraint(equalTo: photoLikesLabel.bottomAnchor, constant: verticalBuffer).isActive = true
    photoDescriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: horizontalBuffer).isActive = true
    photoDescriptionLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -horizontalBuffer).isActive = true
  }
  
  class func height(forPhoto photo: Photo, with width: CGFloat) -> CGFloat {
    let headerHeight:CGFloat = 50.0
    let horizontalBuffer:CGFloat = 10.0
    let verticalBuffer:CGFloat = 5.0
    let fontSize:CGFloat = 14.0
    
    let photoHeight = width * 1.1
    
    let font = UIFont.systemFont(ofSize: 14)
    
    let descriptionAttrString = photo.descriptionAttributedString(withFontSize: fontSize)
    let availableWidth = width - (horizontalBuffer * 2)
    
    let descriptionHeight = descriptionAttrString.boundingRect(with: CGSize(width: availableWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).size.height
    
    return headerHeight + photoHeight + font.lineHeight + descriptionHeight + (4 * verticalBuffer)
  }
}

