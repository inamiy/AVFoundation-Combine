import AVFoundation

extension AVPlayer.Status: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown:
            return "unknown"
        case .readyToPlay:
            return "readyToPlay"
        case .failed:
            return "failed"
        @unknown default:
            return "@unknown"
        }
    }
}

extension AVPlayer.TimeControlStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .paused:
            return "paused"
        case .waitingToPlayAtSpecifiedRate:
            return "waitingToPlayAtSpecifiedRate"
        case .playing:
            return "playing"
        @unknown default:
            return "@unknown"
        }
    }
}

extension AVPlayerItem.Status: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown:
            return "unknown"
        case .readyToPlay:
            return "readyToPlay"
        case .failed:
            return "failed"
        @unknown default:
            return "@unknown"
        }
    }
}
