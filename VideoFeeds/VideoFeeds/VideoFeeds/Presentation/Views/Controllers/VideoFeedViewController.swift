//
//  VideoFeedViewController.swift
//  VideoFeeds
//
//  Created by Raj on 16/12/24.
//

import UIKit
import AsyncDisplayKit
import SnapKit

class VideoFeedViewController: UIViewController {
    private var viewModel: VideoFeedViewModel = VideoFeedViewModel(fetchVideosUseCase: DefaultFetchVideosUseCase(repository: DefaultVideoRepository(networkManager: NetworkManager.shared, cacheManager: CacheManager.shared)))
    
    let tableNode = ASTableNode(style: .plain)
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    init() {
        super.init(nibName: nil, bundle: nil)
        tableNode.backgroundColor = .gray
        self.view.addSubnode(tableNode)
        tableNode.dataSource = self
        tableNode.delegate = self
        tableNode.onDidLoad({ _ in
            self.tableNode.view.snp.makeConstraints({ make in
                make.edges.equalToSuperview()
            })
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startSpinner()
        loadVideos()
        viewModel.videosLoaded = {[weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hideSpinner()
                self.tableNode.reloadData()
            }
        }
    }
    
   private func addSpinner() {
        startSpinner()
        view.addSubview(spinner)
    }
    
    private func startSpinner() {
        spinner.startAnimating()
        spinner.isHidden = false
    }
    private func hideSpinner() {
        spinner.stopAnimating()
        spinner.isHidden = true
        tableNode.isHidden = false
    }
    
    // MARK: - Async Method for Loading Videos
    private func loadVideos() {
        Task {
            // Use async/await to load the initial set of videos
            await viewModel.fetchVideos()
        }
    }
}

extension VideoFeedViewController: ASTableDataSource, ASTableDelegate {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        viewModel.videos.count
    }
    
    func tableNode(_ tableNodes: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = VideoCellNode()
        cell.configure(video: viewModel.videos[indexPath.row])
        return cell
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let video = viewModel.videos[indexPath.row]
       showFullScreenVieo(video: video)
        
    }
    
    func showFullScreenVieo(video: Video) {
        guard let url = video.getVideoURL() else { return }
        let vc = FullScreenVideoController(videoURL: url)
        self.present(vc, animated: true)
    }

}
