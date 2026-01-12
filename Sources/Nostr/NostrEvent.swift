import Foundation

/// Minimal typed representation of a Nostr event.
/// Matches the typical event object: { "id": "...", "pubkey": "...", "created_at": 1234567, "kind": 1, "tags": [["p","..."], ...], "content": "..." }
import CryptoKit

public struct NostrEvent: Codable, Identifiable, Equatable {
    public let id: String
    public let pubkey: String
    public let created_at: Int
    public let kind: Int
    public let tags: [[String]]
    public let content: String

    public var createdDate: Date { Date(timeIntervalSince1970: TimeInterval(created_at)) }

    // MARK: - Deterministic serialization for signing (Nostr spec)
    // Nostr signing uses the SHA256 of the serialized array: [0, pubkey, created_at, kind, tags, content]
    public func serializedForSigning() throws -> Data {
        let arr: [Any] = [0, pubkey, created_at, kind, tags, content]
        let data = try JSONSerialization.data(withJSONObject: arr, options: [])
        return data
    }

    /// Compute the event id as the lowercase hex of SHA256(serializedForSigning())
    public func computeIdHex() throws -> String {
        let serialized = try serializedForSigning()
        let digest = SHA256.hash(data: serialized)
        return Data(digest).hexString()
    }

    // Attempt to find a lightning invoice (bolt11) inside content or tags. This is a best-effort parser.
    public func findLightningInvoice() -> String? {
        // look in content first
        if let invoice = NostrEvent.extractBolt11(from: content) {
            return invoice
        }
        // look for invoice-like tags (e.g., ["bolt11", "lnbc..."] or ["l", "lnbc..."])
        for tag in tags {
            if tag.count >= 2 {
                let key = tag[0].lowercased()
                let value = tag[1]
                if key.contains("bolt11") || key == "l" || value.lowercased().starts(with: "lnbc") {
                    return value
                }
            }
        }
        return nil
    }

    static func extractBolt11(from text: String) -> String? {
        // very simple regex: look for substring starting with "lnbc" followed by allowed chars
        // Note: This is a heuristic, not a full validator
        let pattern = "(lnbc[0-9a-zA-Z]*)"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else { return nil }
        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        if let match = regex.firstMatch(in: text, options: [], range: range), let r = Range(match.range(at: 1), in: text) {
            return String(text[r])
        }
        return nil
    }
}

// helpers
fileprivate extension Data {
    func hexString() -> String {
        self.map { String(format: "%02x", $0) }.joined()
    }
}
