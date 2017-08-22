//
//  CreateQuizHeaderCell.swift
//  Movask
//
//  Created by mac on 07.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class CreateQuizHeaderCell: UICollectionViewCell {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var replaceButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var titleTextView: UnderLinedTextView!
    @IBOutlet weak var descriptionTextView: UnderLinedTextView!
    
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    
    var videoPlayer: ASPVideoPlayer?
    
    // Action handlers
    var addVideoHandler: ((UIButton)->())?
    
    override func awakeFromNib() {
        titleTextView.delegate = self
        descriptionTextView.delegate = self
    }
    
    func setVideoPlayer(url: URL) {
        
        if videoPlayer != nil {
            videoPlayer?.removeFromSuperview()
            videoPlayer = nil
        }

        videoPlayer = ASPVideoPlayer(frame: videoView.bounds)
        videoPlayer?.backgroundColor = UIColor.black
        videoPlayer?.videoURLs = [url]
        videoPlayer?.gravity = .aspectFill
        videoPlayer?.shouldLoop = false
        videoPlayer?.tintColor = UIColor.white
        
        videoPlayer?.videoPlayerView.startedVideo = { [unowned self] in
            self.replyButton.isEnabled = false
        }
        videoPlayer?.videoPlayerView.finishedVideo = { [unowned self] in
            self.replyButton.isEnabled = true
        }
        
        videoView.addSubview(videoPlayer!)
    }
    
    // MARK: - Actions
    
    @IBAction func addVideo(_ sender: UIButton) {
        addVideoHandler?(sender)
    }
    
    @IBAction func reply(_ sender: UIButton) {
        
        if videoPlayer != nil {
            videoPlayer?.videoPlayerView.playVideo()
            videoPlayer?.videoPlayerControls.togglePlay()
            videoPlayer?.hideControls()
        }
    }
}

extension CreateQuizHeaderCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        //resize textview to fit text
        switch textView {
        case titleTextView:
            titleHeight.constant = newSize.height
            titleTextView.lineTopConstraint.constant = newSize.height - titleTextView.lineHeightConstraint.constant
        case descriptionTextView:
            descriptionHeight.constant = newSize.height
            descriptionTextView.lineTopConstraint.constant = newSize.height - descriptionTextView.lineHeightConstraint.constant

        default: break
        }
        textView.layoutIfNeeded()
    }
}
