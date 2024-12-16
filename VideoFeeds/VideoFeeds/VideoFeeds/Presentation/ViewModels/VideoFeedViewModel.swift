//
//  VideoFeedViewModel.swift
//  VideoFeeds
//
//  Created by Raj on 16/12/24.
//

import Foundation
import Combine

class VideoFeedViewModel: ObservableObject {
    @Published var videos: [Video] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let fetchVideosUseCase: FetchVideosUseCase
    private var currentPage = 1
    private let limit = 10
    private var hasMoreData = true
    var videosLoaded: (() -> Void)? = nil
    init(fetchVideosUseCase: FetchVideosUseCase) {
        self.fetchVideosUseCase = fetchVideosUseCase
    }

    // Make this method async to handle video fetching
    func loadInitialVideos() async {
        resetPagination()
        await fetchVideos()
    }

    // Async method to fetch videos
    func fetchVideos() async {
        guard hasMoreData else { return }
        isLoading = true

        do {
            let newVideos = try await fetchVideosUseCase.execute(page: currentPage, limit: limit)
            videos.append(contentsOf: newVideos)
            hasMoreData = newVideos.count == limit
            currentPage += 1
            videosLoaded?()
        } catch {
            errorMessage = "Failed to load videos: \(error)"
        }

        isLoading = false
    }

    private func resetPagination() {
        videos.removeAll()
        currentPage = 1
        hasMoreData = true
    }
}

