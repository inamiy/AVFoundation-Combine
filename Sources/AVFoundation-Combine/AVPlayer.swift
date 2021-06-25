import AVFoundation
import Combine

extension AVPlayer {
    public func seekPublisher(
        to time: CMTime,
        toleranceBefore: CMTime = .zero,
        toleranceAfter: CMTime = .zero
    ) -> AnyPublisher<Bool, Never> {
        AnyPublisher.create { [weak self] subscriber in
            guard let self = self else {
                subscriber.send(completion: .finished)
                return AnyCancellable {}
            }

            self.seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter) { isFinished in
                subscriber.send(isFinished)
                subscriber.send(completion: .finished)
            }

            return AnyCancellable {}
        }
    }

    public func periodicTimePublisher(interval: CMTime, queue: DispatchQueue? = nil) -> AnyPublisher<CMTime, Never> {
        AnyPublisher.create { [weak self] subscriber in
            guard let self = self else {
                subscriber.send(completion: .finished)
                return AnyCancellable {}
            }

            let token = self.addPeriodicTimeObserver(forInterval: interval, queue: queue) { time in
                subscriber.send(time)
            }

            return AnyCancellable { [weak self] in
                self?.removeTimeObserver(token)
            }
        }
    }

    public func boundaryTimePublisher(times: [CMTime], queue: DispatchQueue? = nil) -> AnyPublisher<Void, Never> {
        AnyPublisher.create { [weak self] subscriber in
            guard let self = self else {
                subscriber.send(completion: .finished)
                return AnyCancellable {}
            }

            let token = self.addBoundaryTimeObserver(forTimes: times.map(NSValue.init), queue: queue) {
                subscriber.send(())
            }

            return AnyCancellable { [weak self] in
                self?.removeTimeObserver(token)
            }
        }
    }

    /// - Returns: Publisher with one of `unknown`, `readyToPlay`, `failed`.
    public var statusPublisher: AnyPublisher<AVPlayer.Status, Never> {
        publisher(for: \.status)
            .eraseToAnyPublisher()
    }

    /// - Returns: Publisher with one of `paused`, `waitingToPlay`, `playing`.
    public var playingStatusPublisher: AnyPublisher<PlayingStatus, Never> {
        publisher(for: \.timeControlStatus)
            .compactMap { [weak self] status -> PlayingStatus? in
                switch status {
                case .paused:
                    return .paused
                case .waitingToPlayAtSpecifiedRate:
                    return self?.reasonForWaitingToPlay
                        .map { .waitingToPlay(reason: $0) }
                case .playing:
                    return .playing
                @unknown default:
                    return .unknown
                }
            }
            .eraseToAnyPublisher()
    }

    public var errorPublisher: AnyPublisher<Error?, Never> {
        publisher(for: \.error)
            .eraseToAnyPublisher()
    }

    public var ratePublisher: AnyPublisher<Float, Never> {
        publisher(for: \.rate)
            .eraseToAnyPublisher()
    }

    @available(*, deprecated, message: "Does not work. Use `AVAudioSession.sharedInstance().outputVolumePublisher` instead.")
    public var volumePublisher: AnyPublisher<Float, Never> {
        publisher(for: \.volume)
            .eraseToAnyPublisher()
    }

    public var isExternalPlaybackActivePublisher: AnyPublisher<Bool, Never> {
        publisher(for: \.isExternalPlaybackActive)
            .eraseToAnyPublisher()
    }
}
