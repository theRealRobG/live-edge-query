import Foundation
import mamba

struct LastSegmentWriter {
    private let downloader = LastSegmentDownloader()

    func writeLastSegment(
        from playlist: HLSPlaylist,
        recordedLatency latency: PackagerLatency
    ) async throws -> URL {
        let mp4 = try await downloader.lastSegmentMP4(from: playlist)
        let directoryName = "downloaded-segments"
        try FileManager().createDirectory(
            atPath: directoryName,
            withIntermediateDirectories: true,
            attributes: nil
        )
        let fileURL = URL(fileURLWithPath: "\(directoryName)/\(format(date: latency.nowDate)).mp4")
        try mp4.write(to: fileURL)
        return fileURL
    }

    private func format(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd'T'HH-mm-ss.SSSZ"
        return dateFormatter.string(from: date)
    }
}
