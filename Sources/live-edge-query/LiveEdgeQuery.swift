import Foundation
import ArgumentParser

@main
struct LiveEdgeQuery: ParsableCommand {
    @Argument(help: "The URI of the live playlist")
    var uri: String

    func run() throws {
        let manifestService = ManifestService()
        let latencyCalcylator = LatencyCalculator()
        Task {
            do {
                let playlist = try await manifestService.manifest(for: uri)
                let latency = try latencyCalcylator.packagerLatency(from: playlist)
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
}
