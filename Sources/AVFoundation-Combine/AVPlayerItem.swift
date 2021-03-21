import AVFoundation
import Combine

extension AVPlayerItem {
    /// - Returns: Publisher with one of `unknown`, `readyToPlay`, `failed`.
    public var statusPublisher: AnyPublisher<AVPlayerItem.Status, Never> {
        publisher(for: \.status, options: [.initial, .new])
            .eraseToAnyPublisher()
    }

    public var errorPublisher: AnyPublisher<Error?, Never> {
        publisher(for: \.error, options: [.initial, .new])
            .eraseToAnyPublisher()
    }

    public var loadedTimeRangesPublisher: AnyPublisher<[CMTimeRange], Never> {
        publisher(for: \.loadedTimeRanges, options: [.initial, .new])
            .map { $0.map { $0.timeRangeValue } }
            .eraseToAnyPublisher()
    }

    public var seekableTimeRangesPublisher: AnyPublisher<[CMTimeRange], Never> {
        publisher(for: \.seekableTimeRanges, options: [.initial, .new])
            .map { $0.map { $0.timeRangeValue } }
            .eraseToAnyPublisher()
    }

    public var isPlaybackLikelyToKeepUpPublisher: AnyPublisher<Bool, Never> {
        publisher(for: \.isPlaybackLikelyToKeepUp, options: [.initial, .new])
            .eraseToAnyPublisher()
    }

    public var playbackBufferStatePublisher: AnyPublisher<PlayerbackBufferState, Never> {
        Publishers
            .CombineLatest(
                isPlaybackBufferEmptyPublisher,
                isPlaybackBufferFullPublisher
            )
            .compactMap { isEmpty, isFull in
                switch (isEmpty, isFull) {
                case (true, false): return .empty
                case (false, true): return .full
                case (false, false): return .partial
                case (true, true): return nil
                }
            }
            .eraseToAnyPublisher()
    }

    private var isPlaybackBufferEmptyPublisher: AnyPublisher<Bool, Never> {
        publisher(for: \.isPlaybackBufferEmpty, options: [.initial, .new])
            .eraseToAnyPublisher()
    }

    private var isPlaybackBufferFullPublisher: AnyPublisher<Bool, Never> {
        publisher(for: \.isPlaybackBufferFull, options: [.initial, .new])
            .eraseToAnyPublisher()
    }

    var timedMetadataGroupsPublisher: AnyPublisher<[AVTimedMetadataGroup], Never> {
        MetadataPublisher(item: self)
            .eraseToAnyPublisher()
    }

    @available(iOS, introduced: 4.0, deprecated: 13.0, message: "Use `timedMetadataGroupsPublisher` instead.")
    public var timedMetadataPublisher: AnyPublisher<[AVMetadataItem]?, Never> {
        publisher(for: \.timedMetadata, options: [.initial, .new])
            .eraseToAnyPublisher()
    }

    public var didPlayEndToTimePublisher: AnyPublisher<Notification, Never> {
        NotificationCenter.default
            .publisher(for: .AVPlayerItemDidPlayToEndTime, object: self)
            .eraseToAnyPublisher()
    }

    public var failedToPlayToEndTimePublisher: AnyPublisher<Error, Never> {
        NotificationCenter.default
            .publisher(for: .AVPlayerItemFailedToPlayToEndTime, object: self)
            .compactMap { $0.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error }
            .eraseToAnyPublisher()
    }

    public var timeJumpedPublisher: AnyPublisher<Notification, Never> {
        NotificationCenter.default
            .publisher(for: .AVPlayerItemTimeJumped, object: self)
            .eraseToAnyPublisher()
    }

    public var playbackStalledPublisher: AnyPublisher<Notification, Never> {
        NotificationCenter.default
            .publisher(for: .AVPlayerItemPlaybackStalled, object: self)
            .eraseToAnyPublisher()
    }

    public var newAccessLogEntryPublisher: AnyPublisher<AVPlayerItemAccessLog, Never> {
        NotificationCenter.default
            .publisher(for: .AVPlayerItemNewAccessLogEntry, object: self)
            .compactMap { ($0.object as? AVPlayerItem)?.accessLog() }
            .eraseToAnyPublisher()
    }

    public var newErrorLogEntryPublisher: AnyPublisher<AVPlayerItemErrorLog, Never> {
        NotificationCenter.default
            .publisher(for: .AVPlayerItemNewErrorLogEntry, object: self)
            .compactMap { ($0.object as? AVPlayerItem)?.errorLog() }
            .eraseToAnyPublisher()
    }
}
