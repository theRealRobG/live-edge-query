import Foundation
import ArgumentParser
import AppKit
import mamba

@main
struct LiveEdgeQuery: ParsableCommand {
    @Argument(help: "The URI of the live playlist")
    var uri: String

    @Flag(help: "Download the last segment and save to local file")
    var writeLastSegment = false

    func run() throws {
        let manifestService = ManifestService()
        let latencyCalcylator = LatencyCalculator()
        Task {
            do {
                let playlist = try await manifestService.manifest(for: uri)
                let latency = try latencyCalcylator.packagerLatency(from: playlist)
                if writeLastSegment {
                    await downloadAndWriteLastSegment(from: playlist, recordedLatency: latency)
                }
                print("===")
                print("Last segment: \(latency.lastSegmentDate)")
                print("Now:          \(latency.nowDate)")
                print("===")
                print("Packager latency: \(latency.latency)")
                print("===")
                Self.exit(withError: nil)
            } catch {
                Self.exit(withError: error)
            }
        }
        dispatchMain()
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
