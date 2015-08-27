//
//  Animation.swift
//  HackathonAnimationDemo
//
//  Created by Ryohei Komiya on 2015/08/26.
//  Copyright (c) 2015年 HANASAKE PICTURES Inc. All rights reserved.
//

import Foundation
import CoreGraphics

public final class Animation: NSObject {
    public let emotion: Emotion
    public let fps: UInt
    public let size: CGSize
    public let frameURLs: [NSURL]
    
    public enum Emotion: String {
        case Delight    = "delight"
        case Anger      = "anger"
        case Sorrow     = "sorrow"
        case Walk       = "walk"
        
        var name: String { return rawValue }
    }
    
    static func parseJson(jsonData: NSData) -> Animation? {
        var error: NSError?
        if let json = NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments, error: &error) as? NSDictionary where error == nil {
            if let
                emotion = (json["emotion"] as? String).flatMap({ Emotion(rawValue: $0) }),
                fps = json["fps"] as? UInt,
                width = json["size"]?["width"] as? CGFloat,
                height = json["size"]?["height"] as? CGFloat,
                frameURLStrings = json["frames"] as? [String]
            {
                let frameURLs = frameURLStrings.reduce([]) { (acc: [NSURL], urlStr: String) -> [NSURL] in
                    return NSURL(string: urlStr).map { acc + [$0] } ?? acc
                }
                return Animation(emotion, fps, CGSizeMake(width, height), frameURLs)
            }
        }
        
        return nil
    }
    
    private init(_ emotion: Emotion, _ fps: UInt, _ size: CGSize, _ frameURLs: [NSURL]) {
        self.emotion = emotion
        self.fps = fps
        self.size = size
        self.frameURLs = frameURLs
    }
}
