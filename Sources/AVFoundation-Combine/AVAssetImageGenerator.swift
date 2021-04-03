import AVFoundation
import Combine

extension AVAssetImageGenerator {
    public func generateCGImagesPublisher(times: [CMTime])
    -> AnyPublisher<(image: CGImage, requestedTime: CMTime, actualTime: CMTime), Swift.Error> {
        AnyPublisher.create { [weak self] subscriber in
            guard let self = self else {
                subscriber.send(completion: .finished)
                return AnyCancellable {}
            }

            var count: Int64 = 0
            let totalCount = times.count

            let queue = DispatchQueue(label: "com.inamiy.AVAssetImageGenerator.generateCGImagesPublisher")

            self.generateCGImagesAsynchronously(
                forTimes: times.map(NSValue.init(time:))
            ) { requestedTime, cgImage, actualTime, result, error in

                if let error = error {
                    subscriber.send(completion: .failure(error))
                    return
                }

                if result == .succeeded, let cgImage = cgImage {
                    subscriber.send((cgImage, requestedTime, actualTime))
                }

                let currentCount: Int64 = queue.sync {
                    count += 1
                    return count
                }

                if currentCount == totalCount {
                    subscriber.send(completion: .finished)
                }
            }

            return AnyCancellable {
                self.cancelAllCGImageGeneration()
            }
        }
    }
}
