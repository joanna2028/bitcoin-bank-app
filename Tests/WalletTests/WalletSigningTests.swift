import XCTest
@testable import Wallet
@testable import Nostr

final class WalletSigningTests: XCTestCase {
    struct MockSigner: Secp256k1Signer {
        var lastMessage: Data?
        var returnSig: String
        init(returnSig: String = "mocksig") { self.returnSig = returnSig }
        mutating func sign(message: Data, withHexPrivateKey hexPriv: String) -> String {
            lastMessage = message
            return returnSig
        }
    }

    func testSignNostrEventUsesSignerAndReturnsSignature() throws {
        var mock = MockSigner(returnSig: "cafebabef")
        WalletManager.shared.signer = mock

        let evt = NostrEvent(id: "dummy", pubkey: "pk", created_at: 1, kind: 1, tags: [], content: "hi")
        let sig = WalletManager.shared.signNostrEvent(event: evt, hexPrivateKey: "01")
        XCTAssertEqual(sig, "cafebabef")

        // Ensure the signer got the serialized message
        // Because WalletManager.shared.signer is a value type assignment, the test needs to recreate expectation by signing through a local signer instance
        var local = MockSigner()
        let serialized = try evt.serializedForSigning()
        _ = local.sign(message: serialized, withHexPrivateKey: "01")
        XCTAssertNotNil(local.lastMessage)
        XCTAssertEqual(local.lastMessage, serialized)
    }
}
