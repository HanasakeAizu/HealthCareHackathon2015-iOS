//
//  AnimationPlayerView.swift
//  HackathonAnimationDemo
//
//  Created by Ryohei Komiya on 2015/08/27.
//  Copyright (c) 2015年 HANASAKE PICTURES Inc. All rights reserved.
//

import UIKit

public final class AnimationPlayerView: UIImageView {
    public private(set) var playing: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        contentMode = .ScaleAspectFit
    }
    
    /**
    アニメーションを再生する
    
    :param: emotion アニメーションの種類
    :param: completon アニメーションの再生完了後のコールバック
    */
    public func playAnimation(# emotion: Animation.Emotion, completion: (finished: Bool) -> Void = {_ in}) {
        playAnimation(emotion: emotion, repeatCount: 1, fillAfter: false, completion: completion)
    }
    
    /**
    アニメーションを再生する
    
    :param: emotion アニメーションの種類
    :param: repeatCount アニメーションを繰り返し再生する回数
    :param: fillAfter アニメーション終了後に最終フレームの画像を表示し続ける場合はtrueを、そうでない場合はfalseを設定する。
    :param: completon アニメーションの再生完了後のコールバック
    */
    public func playAnimation(# emotion: Animation.Emotion, repeatCount: Int, fillAfter: Bool, completion: (finished: Bool) -> Void = {_ in}) {
        if playing {
            completion(finished: false)
            return
        }
        playing = true
        
        loadAnimationImages(emotion: emotion) { [weak self] images, fps in
            if let imgs = images {
                dispatch_async(dispatch_get_main_queue()) {
                    self?.image = fillAfter ? imgs.last : nil
                    
                    let duration = NSTimeInterval(imgs.count) / NSTimeInterval(fps)
                    
                    self?.animationImages = imgs
                    self?.animationDuration = duration
                    self?.animationRepeatCount = repeatCount
                    self?.startAnimating()
                    
                    let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(duration * NSTimeInterval(repeatCount) * NSTimeInterval(NSEC_PER_SEC)))
                    dispatch_after(delay, dispatch_get_main_queue()) {
                        completion(finished: true)
                        self?.playing = false
                    }
                }
                
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    completion(finished: false)
                    self?.playing = false
                }
            }
        }
    }
    
    private func loadAnimationImages(# emotion: Animation.Emotion, completion: (images: [UIImage!]?, fps: UInt) -> Void = {_ in}) {
        AnimationDownloader.downloader.downloadAnimation(emotion: emotion) { animation in
            if let anim = animation {
                var indexedImages: [Int: UIImage!] = [:]
                
                let imageDownloadOp: NSBlockOperation = {
                    var op = NSBlockOperation()
                    for (idx, frameURL) in enumerate(anim.frameURLs) {
                        op.addExecutionBlock {
                            let semaphore = dispatch_semaphore_create(0)
                            SimpleImageCache.downloadImage(url: frameURL) { image in
                                indexedImages[idx] = image
                                dispatch_semaphore_signal(semaphore)
                            }
                            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
                        }
                    }
                    return op
                    }()
                
                imageDownloadOp.completionBlock = {
                    let images = sorted(indexedImages, { $0.0 < $1.0 }).map { $0.1 }
                    completion(images: images, fps: anim.fps)
                }
                
                let queue = NSOperationQueue()
                queue.addOperation(imageDownloadOp)
                
            } else {
                completion(images: nil, fps: 0)
                
            }
        }
    }
}