//
//  VideoCacheManager.swift
//  VideoFeeds
//
//  Created by Raj on 16/12/24.
//

import Foundation

actor VideoCacheManager {
    private var cachedVideos: [Video] = []

    func getVideos() -> [Video] {
        return cachedVideos
    }

    func saveVideos(_ videos: [Video]) {
        cachedVideos.append(contentsOf: videos)
    }
}


protocol Cacheable {
    var cacheKey: String { get }
}

class VideoData: Codable {
    let data: Data
    init(data: Data) {
        self.data = data
    }
}

class CacheManager {

    static let shared = CacheManager()

    private var memoryCache = NSCache<NSString, VideoData>()
    private let fileManager: FileManager

    init(memoryCacheCapacity: Int = 10 * 1024 * 1024) { // 10 MB
        self.memoryCache = NSCache<NSString, VideoData>()
        self.fileManager = FileManager.default
    }

    func getData(for key: String) -> Data? {
        if let data = memoryCache.object(forKey: key as NSString) {
            return data.data
        }

        guard let url = fileURL(for: key) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        memoryCache.setObject(VideoData(data: data), forKey: key as NSString)
        return data
    }

    func cacheData(_ data: Data, forKey key: String) {
        memoryCache.setObject(VideoData(data: data), forKey: key as NSString)
        guard let url = fileURL(for: key) else { return }
        try? data.write(to: url)
    }

    private func fileURL(for key: String) -> URL? {
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filename = key + ".cache"
        return documentsPath.appendingPathComponent(filename)
    }
}


