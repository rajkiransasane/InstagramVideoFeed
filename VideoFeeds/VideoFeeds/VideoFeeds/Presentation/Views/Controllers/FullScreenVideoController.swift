//
//  FullScreenVideoController.swift
//  VideoFeeds
//
//  Created by Raj on 16/12/24.
//

import Foundation
import UIKit
import AVKit
import SnapKit

class FullScreenVideoController: UIViewController {
    private let videoURL: URL
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    // UI Components
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tintColor = .white
        return button
    }()

    // MARK: - Initializer
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupVideoPlayer()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = view.bounds
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(dismissButton)

        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }

        dismissButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
    }

    // MARK: - Video Player Setup
    private func setupVideoPlayer() {
        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        if let playerLayer = playerLayer {
            view.layer.insertSublayer(playerLayer, at: 0)
        }
        player?.play()
    }

    // MARK: - Actions
    @objc private func dismissTapped() {
        player?.pause()
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Deinit
    deinit {
        player?.pause()
        player = nil
    }
}
