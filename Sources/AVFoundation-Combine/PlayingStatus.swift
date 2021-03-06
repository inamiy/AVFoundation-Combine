import AVFoundation

/// Enhanced `AVPlayer.TimeControlStatus`.
public enum PlayingStatus: Hashable {
    case paused

    /// - reason: One of `noItemToPlay`, `evaluatingBufferingRate`, `toMinimizeStalls`.
    case waitingToPlay(reason: AVPlayer.WaitingReason)

    case playing

    /// @unknown default
    case unknown
}
