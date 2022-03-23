import AVFoundation

/// Enhanced `AVPlayer.TimeControlStatus`.
public enum PlayingStatus: Hashable, Sendable {
    case paused

    /// - reason: One of `noItemToPlay`, `evaluatingBufferingRate`, `toMinimizeStalls`.
    case waitingToPlay(reason: AVPlayer.WaitingReason)

    case playing

    /// @unknown default
    case unknown
}

extension AVPlayer.WaitingReason: @unchecked Sendable {}
