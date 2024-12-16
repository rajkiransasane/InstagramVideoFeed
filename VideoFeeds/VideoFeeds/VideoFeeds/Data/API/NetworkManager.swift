//
//  NetworkManager.swift
//  VideoFeeds
//
//  Created by Raj on 16/12/24.
//

import Foundation

protocol NetworkService {
    func fetchVideos(from url: URL, completion: @escaping (Result<[Video], Error>) -> Void)
    func downloadVideo(from url: URL, completion: @escaping (Result<URL, Error>) -> Void)
}

class NetworkManager: NetworkService {

    static let shared = NetworkManager()

    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func fetchVideos(from url: URL, completion: @escaping (Result<[Video], Error>) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(NSError(domain: "NetworkError", code: -1, userInfo: nil)))
                return
            }

            do {
                let videos = try JSONDecoder().decode([Video].self, from: data)
                completion(.success(videos))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func downloadVideo(from url: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filename = url.lastPathComponent

        let destinationURL = documentsPath.appendingPathComponent(filename)

        let downloadTask = session.downloadTask(with: url) { location, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let location = location else { return }

            do {
                try FileManager.default.moveItem(at: location, to: destinationURL)
                completion(.success(destinationURL))
            } catch {
                completion(.failure(error))
            }
        }
        downloadTask.resume()
    }
}
