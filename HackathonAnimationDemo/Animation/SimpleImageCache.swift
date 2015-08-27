//
//  SimpleImageCache.swift
//  HackathonAnimationDemo
//
//  Created by Ryohei Komiya on 2015/08/26.
//  Copyright (c) 2015年 HANASAKE PICTURES Inc. All rights reserved.
//

import UIKit

struct SimpleImageCache {
    private init() {}
    
    static func downloadImage(# url: NSURL, completion: UIImage? -> Void = {_ in}) {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.downloadTaskWithURL(url) { location, _, _ in
            let image = NSData(contentsOfURL: location).flatMap { UIImage(data: $0) }
            completion(image)
        }
        task.resume()
    }
}
