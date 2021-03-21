import AVFoundation
import Combine

extension AVAsset {
    public var durationPublisher: AnyPublisher<CMTime, NSError> {
        loadValuePublisher(keyPath: \.duration)
    }

    public var isPlayablePublisher: AnyPublisher<Bool, NSError> {
        loadValuePublisher(keyPath: \.isPlayable)
    }

    public var tracksPublisher: AnyPublisher<[AVAssetTrack], NSError> {
        loadValuePublisher(keyPath: \.tracks)
    }

    public func loadValuePublisher<T>(keyPath: KeyPath<AVAsset, T>) -> AnyPublisher<T, NSError> {
        AnyPublisher.create { [weak self] subscriber in
            // NOTE: Using `_kvcKeyPathString` hack.
            guard let self = self, let keyPathString = keyPath._kvcKeyPathString else {
                subscriber.send(completion: .finished)
                return AnyCancellable {}
            }

            self.loadValuesAsynchronously(forKeys: [keyPathString]) { [weak self] in
                guard let self = self else {
                    subscriber.send(completion: .finished)
                    return
                }

                var error: NSError?
                if self.statusOfValue(forKey: keyPathString, error: &error) == .failed,
                   let error = error {
                    subscriber.send(completion: .failure(error))
                    return
                }

                subscriber.send(self[keyPath: keyPath])
            }

            return AnyCancellable { [weak self] in
                self?.cancelLoading() // NOTE: This will cancel other `loadValuesAsynchronously` calls.
            }
        }
    }
}
