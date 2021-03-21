import AVFoundation
import Combine

extension AVPlayerLayer {
    public var isReadyForDisplayPublisher: AnyPublisher<Bool, Never> {
        publisher(for: \.isReadyForDisplay, options: [.initial, .new])
            .eraseToAnyPublisher()
    }
}
