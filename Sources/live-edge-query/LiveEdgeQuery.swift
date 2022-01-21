import Foundation
import ArgumentParser

@main
struct LiveEdgeQuery: ParsableCommand {
    @Argument(help: "The URI of the live playlist")
    var uri: String

    @Flag(help: "Download the last segment and save to local file")
    var writeLastSegment = false

    @Option(help: "Repeat the live edge query indefinitely at the given interval in seconds")
    var pollingInterval: TimeInterval?

    func run() throws {
        runTask()
        dispatchMain()
    }

    private func runTask() {
        let runner = QueryRunner(
            uri: uri,
            writeLastSegment: writeLastSegment
        )
        Task {
            do {
                try await runner.run()
                await taskFinished(withError: nil)
            } catch {
                await taskFinished(withError: error)
            }
        }
    }

    private func taskFinished(withError error: Error?) async {
        guard let pollingInterval = pollingInterval else {
            Self.exit(withError: error)
        }
        error.map { print($0) }
        do {
            try await Task.sleep(nanoseconds: UInt64(pollingInterval * 1_000_000_000))
        } catch {
            Self.exit(withError: error)
        }
        runTask()
    }
}
