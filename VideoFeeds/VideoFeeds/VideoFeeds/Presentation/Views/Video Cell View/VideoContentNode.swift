//
//  VideoContentNode.swift
//  VideoFeeds
//
//  Created by Raj on 16/12/24.
//

import Foundation
import AsyncDisplayKit

class VideoContentNode: ASDisplayNode {
    
    var state: VideoState? // video state
    
    struct Const {
        static let videoRatio: CGFloat = 0.5
        static let stackSpacing: CGFloat = 2.0
        static let insets: UIEdgeInsets = .init(top: 10.0,
                                                left: 15.0,
                                                bottom: 10.0,
                                                right: 15.0)
        static let playIconSize: CGSize = .init(width: 40, height: 40)
        
        static let forgroundColorKey = NSAttributedString.Key.foregroundColor
        static let fontKey = NSAttributedString.Key.font
    }
    
    enum VideoState {
        case readyToPlay(URL)
        case play(URL)
        case pause(URL)
    }
    
    
    lazy var videoNode = { () -> VFVideoNode in
        let node = VFVideoNode(ratio: 0.5,
                               videoGravity: .resizeAspectFill)
        node.backgroundColor = .black.withAlphaComponent(0.5)
        return node
    }()
    
    lazy var titleNode = { () -> ASTextNode in
        let node = ASTextNode()
        node.backgroundColor = .white
        node.maximumNumberOfLines = 2
        return node
    }()
    
    lazy var decriptionNode = { () -> ASTextNode in
        let node = ASTextNode()
        node.backgroundColor = .white
        node.maximumNumberOfLines = 5
        return node
    }()
    
    enum TextStyle {
        case title
        case description
        
        var fontStyle: UIFont {
            switch self {
            case .title: return UIFont.systemFont(ofSize: 14.0,
                                                  weight: .bold)
            case .description: return UIFont.systemFont(ofSize: 10.0,
                                                    weight: .regular)
            }
        }
        
        var fontColor: UIColor {
            switch self {
            case .title: return .black
            case .description: return .gray
            }
        }
        
        func attributedText(_ text: String) -> NSAttributedString {
            let attr = [Const.forgroundColorKey: self.fontColor,
                        Const.fontKey: self.fontStyle]
            return NSAttributedString(string: text,
                                      attributes: attr)
        }
    }
    
    override init() {
        super.init()
        self.backgroundColor = .white
        self.automaticallyManagesSubnodes = true
    }
    
    @objc func replay() {
        self.videoNode.replayVideo()
    }
}

extension VideoContentNode {
    func configure(video: Video) {
        self.titleNode.attributedText = TextStyle.title.attributedText(video.title)
        self.decriptionNode.attributedText = TextStyle.description.attributedText(video.description)
        guard let url = video.getVideoURL() else { return }
        self.videoNode.setVideoAsset(url, isCache: true)
    }
}

// MARK - LayoutSpec
extension VideoContentNode {
    func videoRatioLayout() -> ASLayoutSpec {
        let videoRatioLayout = ASRatioLayoutSpec(ratio: Const.videoRatio,
                                                 child: self.videoNode)
       return videoRatioLayout
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stackLayoutSpec = ASStackLayoutSpec(direction: .vertical,
                                                spacing: Const.stackSpacing,
                                                justifyContent: .start,
                                                alignItems: .stretch,
                                                children: [videoRatioLayout(),
                                                           titleNode,
                                                           decriptionNode])
        return ASInsetLayoutSpec(insets: Const.insets, child: stackLayoutSpec)
    }
}
