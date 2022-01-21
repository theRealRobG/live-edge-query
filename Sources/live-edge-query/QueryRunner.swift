import AppKit
import mamba

struct QueryRunner {
    private let uri: String
    private let writeLastSegment: Bool
    private let manifestService = ManifestService()
    private let latencyCalculator = LatencyCalculator()

    init(
        uri: String,
        writeLastSegment: Bool
    ) {
        self.uri = uri
        self.writeLastSegment = writeLastSegment
    }

    func run() async throws {
        let playlist = try await manifestService.manifest(for: uri)
        let latency = try latencyCalculator.packagerLatency(from: playlist)
        if writeLastSegment {
            await downloadAndWriteLastSegment(from: playlist, recordedLatency: latency)
        }
        print("===")
        print("Last segment: \(latency.lastSegmentDate)")
        print("Now:          \(latency.nowDate)")
        print("===")
        print("Packager latency: \(latency.latency)")
        print("===")
    }

    private func downloadAndWriteLastSegment(
        from playlist: HLSPlaylist,
        recordedLatency latency: PackagerLatency
    ) async {
        let lastSegmentWriter = LastSegmentWriter()
        do {
            let fileURL = try await lastSegmentWriter.writeLastSegment(from: playlist, recordedLatency: latency)
            NSWorkspace.shared.open(fileURL)
            print("===")
            print("Info: Last segment written to file \(fileURL.absoluteString).")
        } catch {
            print("===")
            print("Warining: Could not write last segment to file.")
            print("\(error)")
        }
    }
}
