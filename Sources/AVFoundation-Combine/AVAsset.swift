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
}
