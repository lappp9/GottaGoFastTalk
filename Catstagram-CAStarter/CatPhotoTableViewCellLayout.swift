
import Foundation


extension CatPhotoTableViewCell {
    func setupConstraints() {
        addConstraintsForAvatar()
        addConstraintsForUserNameLabel()
        addConstraintsForPhotoTimeIntervalSincePostLabel()
        addConstraintsForPhotoImageView()
        addConstraintsForLikesLabel()
        addConstraintsForDescriptionLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let verticalBuffer:CGFloat = 5.0
        let horizontalBuffer:CGFloat = 10.0
        
        var rect = CGRect(x: horizontalBuffer, y: photoLikesLabel.frame.origin.y + photoLikesLabel.bounds.height + verticalBuffer, width: 0, height: 0)
        let availableWidth = bounds.size.width - 20
        
        let firstSize = photoDescriptionLabel1.sizeThatFits(CGSize(width: availableWidth, height: CGFloat.greatestFiniteMagnitude))
        let secondSize = photoDescriptionLabel2.sizeThatFits(CGSize(width: availableWidth, height: CGFloat.greatestFiniteMagnitude))
        let thirdSize = photoDescriptionLabel3.sizeThatFits(CGSize(width: availableWidth, height: CGFloat.greatestFiniteMagnitude))

        rect.size = CGSize(width: firstSize.width, height: firstSize.height + secondSize.height + thirdSize.height)
        
        photoDescriptionContainer.frame = rect
        
        photoDescriptionLabel1.frame = CGRect(x: 0, y: 0, width: firstSize.width, height: firstSize.height)
        photoDescriptionLabel2.frame = CGRect(x: 0, y: firstSize.height, width: firstSize.width, height: firstSize.height)
        photoDescriptionLabel3.frame = CGRect(x: 0, y: firstSize.height + secondSize.height, width: firstSize.width, height: firstSize.height)
//        self.photoDescriptionLabel.frame = CGRect(x: 0, y: 0, width: rect.width, height: 1)
//        UIView.animate(withDuration: 0.45, delay: 0.0, options: [.repeat, .autoreverse], animations: {
//            self.photoDescriptionLabel.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
//        }, completion: nil)
    }
    
    func addConstraintsForAvatar() {
        let horizontalBuffer:CGFloat = 10.0
        
        addConstraint(NSLayoutConstraint(item: userAvatarImageView, attribute: .left, relatedBy: .equal, toItem: userAvatarImageView.superview, attribute: .left, multiplier: 1.0, constant: horizontalBuffer))
        addConstraint(NSLayoutConstraint(item: userAvatarImageView, attribute: .top, relatedBy: .equal, toItem: userAvatarImageView.superview, attribute: .top, multiplier: 1.0, constant: horizontalBuffer))
        addConstraint(NSLayoutConstraint(item: userAvatarImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: userImageHeight))
        addConstraint(NSLayoutConstraint(item: userAvatarImageView, attribute: .height, relatedBy: .equal, toItem: userAvatarImageView, attribute: .width, multiplier: 1.0, constant: 0.0))
    }
    
    func addConstraintsForUserNameLabel() {
        let horizontalBuffer:CGFloat = 10.0
        
        addConstraint(NSLayoutConstraint(item: userNameLabel, attribute: .left, relatedBy: .equal, toItem: userAvatarImageView, attribute: .right, multiplier: 1.0, constant: horizontalBuffer))
        addConstraint(NSLayoutConstraint(item: userNameLabel, attribute: .right, relatedBy: .lessThanOrEqual, toItem: photoTimeIntervalSincePostLabel, attribute: .left, multiplier: 1.0, constant: -horizontalBuffer))
        
        userNameYPositionWithoutPhotoLocation = NSLayoutConstraint(item: userNameLabel, attribute: .centerY, relatedBy: .equal, toItem: userAvatarImageView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        addConstraint(userNameYPositionWithoutPhotoLocation)
    }
    
    func addConstraintsForPhotoTimeIntervalSincePostLabel() {
        let horizontalBuffer:CGFloat = 10.0
        
        addConstraint(NSLayoutConstraint(item: photoTimeIntervalSincePostLabel, attribute: .right, relatedBy: .equal, toItem: photoTimeIntervalSincePostLabel.superview, attribute: .right, multiplier: 1.0, constant: -horizontalBuffer))
        addConstraint(NSLayoutConstraint(item: photoTimeIntervalSincePostLabel, attribute: .centerY, relatedBy: .equal, toItem: userAvatarImageView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
    }
    
    func addConstraintsForPhotoImageView() {
        let headerHeight:CGFloat = 50.0
        
        addConstraint(NSLayoutConstraint(item: photoImageView, attribute: .top, relatedBy: .equal, toItem: photoImageView.superview, attribute: .top, multiplier: 1.0, constant: headerHeight))
        addConstraint(NSLayoutConstraint(item: photoImageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.1, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: photoImageView, attribute: .height, relatedBy: .equal, toItem: photoImageView, attribute: .width, multiplier: 1.0, constant: 0.0))
    }
    
    func addConstraintsForLikesLabel() {
        let verticalBuffer:CGFloat = 5.0
        let horizontalBuffer:CGFloat = 10.0
        
        addConstraint(NSLayoutConstraint(item: photoLikesLabel, attribute: .top, relatedBy: .equal, toItem: photoImageView, attribute: .bottom, multiplier: 1.0, constant: verticalBuffer))
        
        addConstraint(NSLayoutConstraint(item: photoLikesLabel, attribute: .left, relatedBy: .equal, toItem: photoLikesLabel.superview, attribute: .left, multiplier: 1.0, constant: horizontalBuffer))
    }
    
    func addConstraintsForDescriptionLabel() {
        
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        userNameYPositionWithoutPhotoLocation.isActive = true
    }
    
    class func height(forPhoto photoModel: PhotoModel, with width: CGFloat) -> CGFloat {
        let headerHeight:CGFloat = 50.0
        let horizontalBuffer:CGFloat = 10.0
        let verticalBuffer:CGFloat = 5.0
        let fontSize:CGFloat = 14.0
        
        let photoHeight = width * 1.1
        
        let font = UIFont.systemFont(ofSize: 14)
        
        let descriptionAttrString1 = photoModel.descriptionAttributedString(withFontSize: fontSize)
        let descriptionAttrString2 = photoModel.descriptionAttributedString(withFontSize: fontSize)
        let descriptionAttrString3 = photoModel.descriptionAttributedString(withFontSize: fontSize)
        
        let availableWidth = width - (horizontalBuffer * 2);
        
        let descriptionHeight1 = descriptionAttrString1.boundingRect(with: CGSize(width: availableWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).size.height
        let descriptionHeight2 = descriptionAttrString2.boundingRect(with: CGSize(width: availableWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).size.height
        let descriptionHeight3 = descriptionAttrString3.boundingRect(with: CGSize(width: availableWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).size.height
        
        return headerHeight + photoHeight + font.lineHeight + descriptionHeight1 + descriptionHeight2 + descriptionHeight3 + (4 * verticalBuffer)
    }
}
