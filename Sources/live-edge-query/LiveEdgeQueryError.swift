import Foundation

enum LiveEdgeQueryError: CustomNSError {
    case invalidURL
    case unexpectedStatusCode(Int)
    case emptyResponseBody
    case noSegments
    case noDate
    case dateNotParsable

    static let errorDomain = "LiveEdgeQueryError"

    var errorCode: Int {
        switch self {
        case .invalidURL: return 1
        case .unexpectedStatusCode: return 2
        case .emptyResponseBody: return 3
        case .noSegments: return 4
        case .noDate: return 5
        case .dateNotParsable: return 6
        }
    }

    var errorUserInfo: [String : Any] {
        switch self {
        case .invalidURL: return [NSLocalizedDescriptionKey: "Invalid URL."]
        case .unexpectedStatusCode(let code): return [NSLocalizedDescriptionKey: "Unexpected status: \(code)."]
        case .emptyResponseBody: return [NSLocalizedDescriptionKey: "Empty response."]
        case .noSegments: return [NSLocalizedDescriptionKey: "No segments in playlist."]
        case .noDate: return [NSLocalizedDescriptionKey: "No program date time in playlist."]
        case .dateNotParsable: return [NSLocalizedDescriptionKey: "Could not parse date."]
        }
    }
}
