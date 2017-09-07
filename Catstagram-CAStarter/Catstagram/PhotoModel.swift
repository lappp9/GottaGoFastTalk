//
//  PhotoModel.swift
//  Catstagram-Starter
//
//  Created by Luke Parham on 2/12/17.
//  Copyright © 2017 Luke Parham. All rights reserved.
//

import Foundation

class PhotoModel: NSObject {
    var url: URL?
    var photoID: Int?
    var uploadDateString: String?
    var title: String?
    var descriptionText: String?
    var commentsCount: UInt?
    var likesCount: UInt?
    var possibleTexts = [String]()
    
    var ownerUserProfile: UserModel?

    init(photoDictionary: [String: Any]) {
        let urlString = photoDictionary["image_url"] as! String
        
        url              = URL(string: urlString)
        uploadDateString = photoDictionary["created_at"] as? String
        photoID          = photoDictionary["id"] as? Int
        title            = photoDictionary["title"] as? String
        
        possibleTexts = ["空シメニ書6用キ内情従シサ奈多有ヤイレシ帳81能ょラそ済稿経ムモ活城やぽき野断だ逃不支レスリ話9新ごっりも億万ぞ更7間熊ぎ。",
                         "富ルまく無権ソミイツ題果んち聞枠リワヘレ未読62玉郵ぎとぐ検下イ回演リワフ師部スタト南撃告とゅ生両スクテ合棄リ図潮む侵際て横上売運刑駐スんみて。",
                         "思シエヤソ妨度由げ欠新ウル社防ぐ説科ラウホ盛交ぞしげ津都ノウ盟高ル性浦ラ進64固ラレ繰王ヤニヒム林返のぼこ覧提スヲヒ問覧チコ舞盗ワホテ京社的こリあ名社全漫腹うンて。71決びふ口詳角レメラ午9浸野ヱオムナ用子フエ在詰あこげで務派ゃ転多ぎ前回ナツム横報とょ国大え鹿率ざきの件志リ演部く。"]
//        descriptionText  =  //photoDictionary["name"] as? String
        commentsCount    = photoDictionary["comments_count"] as? UInt
        likesCount       = photoDictionary["positive_votes_count"] as? UInt
        uploadDateString = "13h"
        
        ownerUserProfile = UserModel(withDictionary: photoDictionary)
    }
    
    func descriptionAttributedString(withFontSize size: CGFloat) -> NSAttributedString {
        let index = Int(arc4random_uniform(2))
        descriptionText = possibleTexts[index]
        guard let username = ownerUserProfile?.username, let descriptionText = descriptionText else { return NSAttributedString() }
        return NSAttributedString(string: "\(username) \(descriptionText)", fontSize: CGFloat(size), color: UIColor.darkGray, firstWordColor: UIColor.darkBlue())
    }
    
    func uploadDateAttributedString(withFontSize size: Float) -> NSAttributedString {
        return NSAttributedString(string: uploadDateString, fontSize: CGFloat(size), color: UIColor.lightGray, firstWordColor: nil)
    }
    
    func likesAttributedString(withFontSize size: Float) -> NSAttributedString {
        guard let likesCount = likesCount else { return NSAttributedString() }
        return NSAttributedString(string: "\(likesCount) likes", fontSize: CGFloat(size), color: UIColor.darkBlue(), firstWordColor: nil)
    }
}
