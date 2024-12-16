//
//  FetchVideosUseCase.swift
//  VideoFeeds
//
//  Created by Raj on 16/12/24.
//

import Foundation

protocol FetchVideosUseCase {
    func execute(page: Int, limit: Int) async throws -> [Video]
}

class DefaultFetchVideosUseCase: FetchVideosUseCase {
    private let repository: VideoRepository

    init(repository: VideoRepository) {
        self.repository = repository
    }

    func execute(page: Int, limit: Int) async throws -> [Video] {
        return try await repository.fetchVideos(page: page, limit: limit)
    }
}


