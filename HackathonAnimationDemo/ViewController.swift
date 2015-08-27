//
//  ViewController.swift
//  HackathonAnimationDemo
//
//  Created by Ryohei Komiya on 2015/08/26.
//  Copyright (c) 2015年 HANASAKE PICTURES Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var delightView: UIView!
    @IBOutlet weak var angerView: UIView!
    @IBOutlet weak var sorrowView: UIView!
    @IBOutlet weak var walkView: UIView!
    
    @IBOutlet weak var delightPlayerView: AnimationPlayerView!
    @IBOutlet weak var angerPlayerView: AnimationPlayerView!
    @IBOutlet weak var sorrowPlayerView: AnimationPlayerView!
    @IBOutlet weak var walkPlayerView: AnimationPlayerView!
    
    @IBOutlet weak var delightClickLabel: UILabel!
    @IBOutlet weak var angerClickLabel: UILabel!
    @IBOutlet weak var sorrowClickLabel: UILabel!
    @IBOutlet weak var walkClickLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func setupClickEvent(target: UIView, selector: Selector) {
            let gr = UITapGestureRecognizer(target: self, action: selector)
            target.addGestureRecognizer(gr)
        }
        
        setupClickEvent(delightView, "delightViewDidClick:")
        setupClickEvent(angerView, "angerViewDidClick:")
        setupClickEvent(sorrowView, "sorrowViewDidClick:")
        setupClickEvent(walkView, "walkViewDidClick:")
    }
    
    func delightViewDidClick(sender: AnyObject) {
        playAnimation(emotion: .Delight, playerView: delightPlayerView, clickLabelView: delightClickLabel)
    }
    func angerViewDidClick(sender: AnyObject) {
        playAnimation(emotion: .Anger, playerView: angerPlayerView, clickLabelView: angerClickLabel)
    }
    func sorrowViewDidClick(sender: AnyObject) {
        playAnimation(emotion: .Sorrow, playerView: sorrowPlayerView, clickLabelView: sorrowClickLabel)
    }
    func walkViewDidClick(sender: AnyObject) {
        playAnimation(emotion: .Walk, playerView: walkPlayerView, clickLabelView: walkClickLabel)
    }
    
    private func playAnimation(# emotion: Animation.Emotion, playerView: AnimationPlayerView, clickLabelView: UILabel) {
        clickLabelView.hidden = true
        playerView.playAnimation(emotion: emotion, repeatCount: 3, fillAfter: true) { [weak clickLabelView] finished in
            if finished {
                clickLabelView?.hidden = false
            }
        }
    }
}

