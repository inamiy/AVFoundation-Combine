import AVFoundation
import Combine

// Conforming Types: `AVAsset`, `AVAssetTrack`, `AVMetadataItem`
extension AVAsynchronousKeyValueLoading {
    public func loadValuePublisher<T>(keyPath: KeyPath<Self, T>) -> AnyPublisher<T, NSError> {
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

            return AnyCancellable {}
        }
    }
}
