import Foundation
import mamba

class ManifestService {
    private let networkService = NetworkService()
    private let parser = HLSParser()

    func manifest(for uri: String) async throws -> HLSPlaylist {
        guard let url = URL(string: uri) else {
            throw LiveEdgeQueryError.invalidURL
        }
        guard let data = try await networkService.data(for: url) else {
            throw LiveEdgeQueryError.emptyResponseBody
        }
        return try parser.parse(playlistData: data, url: url)
    }
}
