import AVFoundation
import Combine

#if !os(macOS)
extension AVAudioSession {
    public var outputVolumePublisher: AnyPublisher<Float, Never> {
        publisher(for: \.outputVolume)
            .eraseToAnyPublisher()
    }
}
#endif
