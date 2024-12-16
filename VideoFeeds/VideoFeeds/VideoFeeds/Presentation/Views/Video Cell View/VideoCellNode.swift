//
//  VideoCellNode.swift
//  VideoFeeds
//
//  Created by Raj on 16/12/24.
//

import Foundation

import AsyncDisplayKit
import UIKit

class VideoCellNode: ASCellNode {
    lazy var videoNode = VideoContentNode()
    
    struct Const {
        static let insets: UIEdgeInsets = .init(top: 10,
                                                left: 10,
                                                bottom: 10,
                                                right: 10)
    }
    
    override init() {
        super.init()
        self.selectionStyle = .none
        self.automaticallyManagesSubnodes = true
    }
    
    func configure(video: Video) {
        videoNode.configure(video: video)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: Const.insets,
                                 child: videoNode)
    }
}
