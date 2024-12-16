//
//  VFVideoNode.swift
//  VideoFeeds
//
//  Created by Raj on 16/12/24.
//


import Foundation
import AsyncDisplayKit

class VFVideoNode: ASDisplayNode {
    fileprivate var state: VideoState? // video state
    private let ratio: CGFloat
    private let automaticallyPause: Bool // Recommend true
    private let videoGravity: AVLayerVideoGravity
    private var willCache: Bool = true
    
    fileprivate lazy var videoNode = { () -> ASVideoNode in
        let node = ASVideoNode()
        node.shouldAutoplay = false
        node.shouldAutorepeat = false
        node.muted = true
        return node
    }()
    
    enum VideoState {
        case readyToPlay(URL)
        case play(URL)
        case pause(URL)
    }
    
    required init(ratio: CGFloat,
                  videoGravity: AVLayerVideoGravity,
                  automaticallyPause: Bool = true) {
        self.ratio = ratio
        self.videoGravity = videoGravity
        self.automaticallyPause = automaticallyPause
        super.init()
        self.automaticallyManagesSubnodes = true

    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASRatioLayoutSpec(ratio: self.ratio, child: self.videoNode)
    }
    
    
    func setVideoAsset(_ url: URL, isCache: Bool = true) {
        self.willCache = isCache
        self.state = .readyToPlay(url)
        let asset = AVAsset(url: url)
        asset.loadValuesAsynchronously(forKeys: ["playable"], completionHandler: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
                asset.cancelLoading()
                self.videoNode.asset = asset
                self.playVideo(forcePlay: true)
            })
        })
    }
}

// MARK - Intelligent Preloading LifeCycle
extension VFVideoNode {
    override func didEnterVisibleState() {
        super.didEnterVisibleState()
        self.playVideo()
    }
    
    override func didExitVisibleState() {
        super.didExitVisibleState()
        if automaticallyPause {
            self.pauseVideo()
        }
    }
}

// MARK - Video ControlEvent
extension VFVideoNode {
    func replayVideo() {
        guard let state = self.state, case .pause(let url) = state else { return }
        self.state = .readyToPlay(url)
        self.playVideo(forcePlay: true)
    }
    
    func playVideo(forcePlay: Bool = false) {
        guard let state = self.state, case .readyToPlay(let url) = state else { return }
        self.videoNode.play()
        self.videoNode.playerLayer?.videoGravity = self.videoGravity
        self.state = .play(url)
    }
    
    func pauseVideo() {
        guard let state = self.state, case .play(let url) = state else { return }
        self.videoNode.pause()
        self.videoNode.asset?.cancelLoading()
        if !self.willCache {
            self.videoNode.asset = nil
        }
        self.state = .pause(url)
    }
}
