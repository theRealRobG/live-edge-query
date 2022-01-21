import Foundation

class NetworkService {
    func data(for url: URL) async throws -> Data? {
        try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    return continuation.resume(throwing: error)
                }
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 400 {
                    return continuation.resume(throwing: LiveEdgeQueryError.unexpectedStatusCode(statusCode))
                }
                continuation.resume(returning: data)
            }.resume()
        }
    }
}
