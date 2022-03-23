public enum PlaybackBufferState: Hashable, Sendable {
    /// Buffer is empty.
    case empty

    /// Buffer is partially filled.
    case partial

    /// Buffer is full.
    case full
}
