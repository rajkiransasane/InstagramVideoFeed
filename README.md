# InstagramVideoFeed

# Video Fetcher and Downloader

A Swift-based project implementing a modular video fetching and downloading framework using **MVVM** and **Clean Architecture**. The app leverages modern networking techniques, asynchronous programming, and dependency management. With a user-friendly interface built on Texture (AsyncDisplayKit) and SnapKit for layout management, this project follows **SOLID principles** to ensure scalability and testability.

---
## Video


https://github.com/user-attachments/assets/c96331ad-fe11-4c1d-b4fe-456c0aba5f20


## Features

- Fetch videos from a remote server or a local JSON file.
- Download videos for offline access with progress tracking.
- Cache video metadata and downloaded files.
- Implements **MVVM + Clean Architecture** for separation of concerns.
- Built using **Texture** (AsyncDisplayKit) for smooth UI rendering.
- Responsive UI layout powered by **SnapKit**.

---

## Architecture Overview

This project uses **MVVM + Clean Architecture** to ensure modularity, testability, and maintainability. The architecture comprises the following layers:

1. **Models**: Defines core data structures (e.g., `Video`).
2. **ViewModels**: Encapsulates business logic, binds data, and handles user interactions.
3. **Use Cases**: Encapsulates specific application logic (e.g., fetching or downloading videos).
4. **Repositories**: Abstracts data sources (e.g., remote APIs, local cache).
5. **Networking**: Handles HTTP requests and video downloads.
6. **Views**: Renders the user interface using Texture (AsyncDisplayKit).

---

## Project Structure

```
- Network
  - NetworkManager.swift
- Repository
  - VideoRepository.swift
- UseCases
  - FetchVideosUseCase.swift
- ViewModels
  - VideoFeedViewModel.swift
- Views
  - VideoFeedViewController.swift
  - VideoCellNode.swift
  - VideoContentNode.swift
- Models
  - Video.swift
```

### Key Files

1. **`NetworkManager.swift`**
   - Defines the `NetworkService` protocol and its implementation.
   - Fetches video metadata and downloads video files.

2. **`VideoRepository.swift`**
   - Implements the `VideoRepository` protocol.
   - Manages fetching and caching video data.

3. **`FetchVideosUseCase.swift`**
   - Encapsulates logic for fetching video metadata asynchronously.
   - Supports pagination and error handling.

4. **`VideoFeedViewModel.swift`**
   - Serves as the ViewModel for the video feed.
   - Manages data flow between use cases and views.

5. **`VideoFeedViewController.swift`**
   - A Texture-based `ASTableNode` view controller for displaying the video feed.
   - Handles UI events and binds to the ViewModel.

6. **`VideoCellNode.swift`**
   - A Texture-based UI component for rendering individual video items.

7. **`Video.swift`**
   - Defines the `Video` model conforming to `Codable` and `Cacheable`.

---

## Dependencies

This project uses the following CocoaPods dependencies:

- **SnapKit (~> 5.7.0)**: Declarative UI layout using constraints.
- **Texture**: Asynchronous UI rendering framework for smooth performance.

To install dependencies, run:

```bash
pod install
```

---

## How to Run

### Prerequisites

- Xcode 14.0 or later
- iOS 15.0 or later
- Swift 5.5 or later

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/videofetcher.git
   cd videofetcher
   ```

2. Install dependencies:
   ```bash
   pod install
   ```

3. Open the `.xcworkspace` file in Xcode:
   ```bash
   open VideoFetcher.xcworkspace
   ```

4. Build and run the project on the iOS simulator or a physical device.

---

## Example Usage

### Fetching Videos

```swift
let useCase = DefaultFetchVideosUseCase(repository: DefaultVideoRepository(
    networkManager: NetworkManager.shared,
    cacheManager: CacheManager.shared
))

Task {
    do {
        let videos = try await useCase.execute(page: 1, limit: 10)
        print("Fetched videos: \(videos)")
    } catch {
        print("Failed to fetch videos: \(error)")
    }
}
```

### Downloading a Video

```swift
if let video = videos.first, let url = video.getVideoURL() {
    Task {
        do {
            let localURL = try await repository.downloadVideo(video: video)
            print("Downloaded video to: \(localURL)")
        } catch {
            print("Failed to download video: \(error)")
        }
    }
}
```

---

## UI Preview

- **Video Feed**: A list of videos rendered using Texture's `ASTableNode`.
- **Video Cell**: Each cell displays a thumbnail, title, and description.
- **Full-Screen Video**: Tapping a video opens it in a full-screen player.

---

## Key Concepts

### MVVM + Clean Architecture
The project separates concerns into clearly defined layers:
- **Models** handle data representation.
- **ViewModels** encapsulate business logic and bind data to views.
- **Views** focus on UI rendering with Texture.

### Protocol-Oriented Design
Protocols like `NetworkService`, `VideoRepository`, and `FetchVideosUseCase` ensure testability and flexibility.

### Dependency Injection
Dependencies like `NetworkManager` and `CacheManager` are injected via initializers to decouple components.

### Asynchronous Programming
Leverages Swift's `async/await` APIs for clean, maintainable code.

---

## Future Improvements

- Add unit tests for `NetworkManager`, `VideoRepository`, and `FetchVideosUseCase`.
- Improve caching with expiration policies and size limits.
- Implement download progress tracking in the UI.
- Localize the app for multiple languages.

---

## License
Free

---

## Author

[Rajkiran Sasane](https://github.com/rajsasane)

