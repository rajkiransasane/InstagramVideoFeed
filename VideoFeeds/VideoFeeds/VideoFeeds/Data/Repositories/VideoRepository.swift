//
//  VideoRepository.swift
//  VideoFeeds
//
//  Created by Raj on 16/12/24.
//

import Foundation


protocol VideoRepository {
    func fetchVideos(page: Int, limit: Int) async throws -> [Video]
    func downloadVideo(video: Video) async throws -> URL
}

class DefaultVideoRepository: VideoRepository {
    func fetchVideos(page: Int, limit: Int) async throws -> [Video] {
        if EnvironmentType.defaultEnvType() == .stage {
            // Delay the task by 3 second:
            try await Task.sleep(nanoseconds: 3_000_000_000)
            return try await loadJson(filename: "DummyVideos") ?? []
        } else {
            return try await fetchVideos()
        }
    }
    
    private let networkManager: NetworkService
    private let cacheManager: CacheManager

    init(networkManager: NetworkService, cacheManager: CacheManager) {
        self.networkManager = networkManager
        self.cacheManager = cacheManager
    }

    func loadJson(filename fileName: String) async throws -> [Video]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Video].self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }

    func fetchVideos() async throws -> [Video] {
        let url = URL(string: "https://github.com/rajkiransasane/dummyVideo/blob/main/DummyVideos.json")! // Replace with your API endpoint
        return try await withCheckedThrowingContinuation { continuation in
            networkManager.fetchVideos(from: url) { result in
                switch result {
                case .success(let videos):
                    continuation.resume(returning: videos)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func downloadVideo(video: Video) async throws -> URL {
        return URL(string:video.sources.first ?? "")!
       /* if let cachedData = cacheManager.getData(for: video.cacheKey) {
            return URL(fileURLWithPath: cacheManager.cacheDirectory).appendingPathComponent(video.cacheKey)
        } else {
            let url = video.fullVideoURL
            return try await withCheckedThrowingContinuation { continuation in
                networkManager.downloadVideo(from: url) { result in
                    switch result {
                    case .success(let downloadedURL):
                        cacheManager.cacheData(downloadedURL, forKey: video.cacheKey)
                        continuation.resume(returning: downloadedURL)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
        */
    }
}
