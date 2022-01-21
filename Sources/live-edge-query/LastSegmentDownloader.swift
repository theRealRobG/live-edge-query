import Foundation
import mamba

struct LastSegmentDownloader {
    private let networkService = NetworkService()

    func lastSegmentMP4(from playlist: HLSPlaylist) async throws -> Data {
        let mapURL = try lastMapURL(from: playlist)
        let segmentURL = try lastSegmentURL(from: playlist)
        async let map = networkService.data(for: mapURL)
        async let segment = networkService.data(for: segmentURL)
        guard let mapData = try await map, let segmentData = try await segment else {
            throw LiveEdgeQueryError.invalidSegmentData
        }
        var completeMP4 = mapData
        completeMP4.append(segmentData)
        return completeMP4
    }

    private func lastMapURL(from playlist: HLSPlaylist) throws -> URL {
        let url = playlist.tags
            .last { $0.tagDescriptor == PantosTag.EXT_X_MAP }?
            .value(forValueIdentifier: PantosValue.uri)
            .flatMap { URL(string: $0, relativeTo: playlist.url) }
        guard let url = url else { throw LiveEdgeQueryError.noMap }
        return url
    }

    private func lastSegmentURL(from playlist: HLSPlaylist) throws -> URL {
        guard let location = playlist.tags.last(where: { $0.tagDescriptor == PantosTag.Location }) else {
            throw LiveEdgeQueryError.noSegments
        }
        guard let url = URL(string: location.tagData.stringValue(), relativeTo: playlist.url) else {
            throw LiveEdgeQueryError.invalidSegmentURL
        }
        return url
    }
}
