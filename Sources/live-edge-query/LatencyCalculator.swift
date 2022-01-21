import Foundation
import mamba

struct LatencyCalculator {
    func packagerLatency(from playlist: HLSPlaylist) throws -> PackagerLatency {
        let mediaSegmentGroups = playlist.mediaSegmentGroups
        let lastIndex = mediaSegmentGroups.count - 1
        guard lastIndex >= 0 else { throw LiveEdgeQueryError.noSegments }
        let lastIndexOfPDT = mediaSegmentGroups.lastIndex { segmentGroup in
            playlist.tags(forMediaGroup: segmentGroup).contains {
                $0.tagDescriptor == PantosTag.EXT_X_PROGRAM_DATE_TIME
            }
        }
        guard let lastIndexOfPDT = lastIndexOfPDT else { throw LiveEdgeQueryError.noDate }
        let extraTime = mediaSegmentGroups[lastIndexOfPDT..<lastIndex].reduce(0.0) { sum, segmentGroup in
            let inf = playlist.tags(forMediaGroup: segmentGroup).first { $0.tagDescriptor == PantosTag.EXTINF }
            guard let duration = inf?.tagData.extinfSegmentDuration().seconds else { return sum }
            return sum + duration
        }
        let pdt = playlist.tags(forMediaGroupIndex: lastIndexOfPDT).first {
            $0.tagDescriptor == PantosTag.EXT_X_PROGRAM_DATE_TIME
        }
        guard let pdt = pdt else { throw LiveEdgeQueryError.noDate }
        guard let date = pdt.value(forValueIdentifier: PantosValue.programDateTime) as Date? else {
            throw LiveEdgeQueryError.dateNotParsable
        }
        let lastSegmentDate = date.advanced(by: extraTime)
        let now = Date()
        return PackagerLatency(
            lastSegmentDate: lastSegmentDate,
            nowDate: now,
            latency: now.timeIntervalSince(lastSegmentDate)
        )
    }
}
