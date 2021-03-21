import AVFoundation
import Combine

extension AVAudioSession {
    public var outputVolumePublisher: AnyPublisher<Float, Never> {
        publisher(for: \.outputVolume)
            .eraseToAnyPublisher()
    }
}
