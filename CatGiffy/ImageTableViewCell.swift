//
//  ImageTableViewCell.swift
//  CatGiffy
//
//  Created by codebendr on 23/06/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import UIKit
import Kingfisher

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    
    override func prepareForReuse() {
        img.image = nil
    }
    
    var gif: Image? {
        didSet {
            if let gif = gif {
                if let url = URL(string: gif.url) {
                    img.kf.indicatorType = .activity
                    img.kf.setImage(with: url,options: [.transition(.fade(0.2)),.cacheSerializer(FormatIndicatedCacheSerializer.gif)])
                    
                }
                
            }
        }
    }
}
