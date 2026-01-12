import XCTest
@testable import Nostr
import CryptoKit

final class NostrSerializationTests: XCTestCase {
    func testSerializedForSigningProducesExpectedArrayJSON() throws {
        let evt = NostrEvent(
            id: "dummy",
            pubkey: "0123456789abcdef",
            created_at: 1600000000,
            kind: 1,
            tags: [["p","abcd"]],
            content: "hello"
        )

        let data = try evt.serializedForSigning()
        // Verify it's valid JSON and an array with first element 0
        let any = try JSONSerialization.jsonObject(with: data, options: [])
        XCTAssertTrue(any is [Any])
        let arr = any as! [Any]
        XCTAssertEqual(arr.count, 6)
        XCTAssertEqual(arr[0] as? Int, 0)
        XCTAssertEqual(arr[1] as? String, "0123456789abcdef")
        XCTAssertEqual(arr[5] as? String, "hello")
    }

    func testComputeIdHexMatchesSHA256OfSerialization() throws {
        let evt = NostrEvent(
            id: "dummy",
            pubkey: "0123456789abcdef",
            created_at: 1600000000,
            kind: 1,
            tags: [["p","abcd"]],
            content: "hello"
        )
        let serialized = try evt.serializedForSigning()
        let digest = SHA256.hash(data: serialized)
        let expectedHex = Data(digest).map { String(format: "%02x", $0) }.joined()
        let computed = try evt.computeIdHex()
        XCTAssertEqual(computed, expectedHex)
    }
}
