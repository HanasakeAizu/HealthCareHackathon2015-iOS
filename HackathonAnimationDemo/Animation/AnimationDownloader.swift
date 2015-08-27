//
//  AnimationDownloader.swift
//  HackathonAnimationDemo
//
//  Created by Ryohei Komiya on 2015/08/26.
//  Copyright (c) 2015年 HANASAKE PICTURES Inc. All rights reserved.
//

import Foundation

public struct AnimationDownloader {
    public static let downloader: AnimationDownloader = AnimationDownloader()
    
    private init() {}
    
    
    
    private let animationCache = NSCache()
    
    /**
    アニメーションデータのプリロード
    */
    public func preloadAnimations() {
        func cacheImages(animation: Animation?) {
            if let urls = animation?.frameURLs {
                for url in urls {
                    SimpleImageCache.downloadImage(url: url)
                }
            }
        }
        
        downloadAnimation(emotion: .Delight, completion: cacheImages)
        downloadAnimation(emotion: .Anger, completion: cacheImages)
        downloadAnimation(emotion: .Sorrow, completion: cacheImages)
        downloadAnimation(emotion: .Walk, completion: cacheImages)
    }
    
    /**
    アニメーションデータを読み込む
    
    :param: emotion アニメーションデータの種類
    :param: completon アニメーションデータの読み込み完了後のコールバック
    */
    public func downloadAnimation(# emotion: Animation.Emotion, completion: (animation: Animation?) -> Void = {_ in}) {
        if let anim = animationCache.objectForKey(emotion.name) as? Animation {
            completion(animation: anim)
            return
        }
        
        if let url = NSURL(string: "http://54.65.195.96/api/v1/animations/\(emotion.name)") {
            let runCompletion: Animation? -> Void = { anim in
                dispatch_async(dispatch_get_main_queue(), {
                    completion(animation: anim)
                })
            }
            
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            let task = session.dataTaskWithURL(url) { [weak animationCache] data, response, error in
                let statusCode = (response as? NSHTTPURLResponse)?.statusCode
                if error != nil || statusCode != 200 {
                    runCompletion(nil)
                }
                
                if let anim = Animation.parseJson(data) {
                    animationCache?.setObject(anim.emotion.name, forKey: emotion.name)
                    runCompletion(anim)
                } else {
                    runCompletion(nil)
                }
            }
            task.resume()
            
        } else {
            completion(animation: nil)
        }
    }
}