//
//  Video.swift
//  VideoFeeds
//
//  Created by Raj on 16/12/24.
//

import Foundation

struct Video: Codable, Cacheable {
    let title: String
    let sources: [String]
    let description: String
    enum CodingKeys: String, CodingKey {
        case title, sources, description
    }
    var cacheKey: String {
        return title
    }
    
    func getVideoURL() -> URL? {
        URL(string: sources.first ?? "")
    }
}

