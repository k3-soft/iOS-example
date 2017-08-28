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
    @IBOutlet weak var replaceView: UIView!
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var replaceButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var titleTextView: UnderLinedTextView!
    @IBOutlet weak var descriptionTextView: UnderLinedTextView!
    
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    
    var quiz: QuizPostTest?
    
    weak var ownerCollectionView: UICollectionView?
    
    var videoPlayer: ASPVideoPlayer?
    
    // Action handlers
    var addVideoHandler: ((UIButton)->())?
    
    static let titleTextAttributes: [String: NSObject] = {
        let font = UIFont(name: MainFontSemibold, size: 21.0)!
        let attributes = [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor.black]
        return attributes
    }()
    
    static let descriptionTextAttributes: [String: NSObject] = {
        let font = UIFont(name: MainFontSemibold, size: 17.0)!
        let attributes = [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor.lightGray]
        return attributes
    }()
    
    override func awakeFromNib() {
        
        titleTextView.delegate = self
        descriptionTextView.delegate = self
        
        titleTextView.attributedText = NSAttributedString(string: "setVideoPlayersetVideosetVideoPlayersetVideosetVideoPlayersetVideosetVideoPlayersetVideosetVideoPlayersetVideosetVideoPlayersetVideosetVideoPlayersetVideosetVideoPlayersetVideosetVideoPlayersetVideosetVideoPlayersetVideosetVideoPlayersetVideosetVideoPlayersetVideosetVideoPlayersetVideosetVideoPlayersetVideosetVideoPlayersetVideo",
                                                          attributes: CreateQuizHeaderCell.titleTextAttributes)
        
        descriptionTextView.attributedText = NSAttributedString(string: "setVideoPlayersetVideoPlsd",
                                                                attributes: CreateQuizHeaderCell.descriptionTextAttributes)
    
        if videoPlayer == nil {
            makeButtonsHidden(true)
        }
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
    
    func makeButtonsHidden(_ hidden: Bool) {
        replaceView.isHidden = hidden
        replyView.isHidden = hidden
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
            quiz?.title = textView.text
            titleHeight.constant = newSize.height
            titleTextView.lineTopConstraint.constant = newSize.height - titleTextView.lineHeightConstraint.constant
            
        case descriptionTextView:
            quiz?.description = textView.text
            descriptionHeight.constant = newSize.height
            descriptionTextView.lineTopConstraint.constant = newSize.height - descriptionTextView.lineHeightConstraint.constant

        default: break
        }
//        textView.layoutIfNeeded()
        
        //update collectionview cell height
        ownerCollectionView?.performBatchUpdates(nil)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
