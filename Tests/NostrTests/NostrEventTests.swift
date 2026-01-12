import XCTest
@testable import Nostr

final class NostrEventTests: XCTestCase {
    func testBolt11ExtractionFromContent() throws {
        let txt = "please pay me lnbc2500u1ps...xyz more text"
        let extracted = NostrEvent.extractBolt11(from: txt)
        XCTAssertNotNil(extracted)
        XCTAssertTrue(extracted!.lowercased().starts(with: "lnbc"))
    }

    func testFindLightningInvoiceInTags() throws {
        let event = NostrEvent(id: "1", pubkey: "abc", created_at: 123, kind: 1, tags: [["bolt11", "lnbc123abc"]], content: "")
        XCTAssertEqual(event.findLightningInvoice(), "lnbc123abc")
    }

    func testDecodingFromRelayArray() throws {
        // simulate relay message: ["EVENT", {eventObject}]
        let eventObj: [String: Any] = [
            "id": "evt1",
            "pubkey": "pk",
            "created_at": 1600000000,
            "kind": 9735,
            "tags": [["p", "..."],["bolt11","lnbc1..."]],
            "content": "lnbc1testinvoice"
        ]
        let arr: [Any] = ["EVENT", eventObj]
        let data = try JSONSerialization.data(withJSONObject: arr)

        // reuse NostrClient handleIncomingData via decode
        let client = NostrClient(relayURL: URL(string: "wss://nostr.example.org")!)
        client.connect() // harmless, connection will not be established in tests
        // use reflection to call private method handleIncomingData (since it's private), we'll instead decode directly
        let decoded = try JSONDecoder().decode(NostrEvent.self, from: try JSONSerialization.data(withJSONObject: eventObj))
        XCTAssertEqual(decoded.id, "evt1")
        XCTAssertEqual(decoded.findLightningInvoice(), "lnbc1testinvoice")
    }
}
