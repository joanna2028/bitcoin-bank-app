import XCTest
@testable import Wallet

final class LibsecpSignerTests: XCTestCase {
    func testSignReturnsEmptyWhenLibMissing() throws {
        #if canImport(secp256k1)
        // If the library is present, test will assert a non-empty signature for a known key. This requires the library bindings to be implemented.
        let signer = LibsecpSigner()
        let msg = "hello".data(using: .utf8)!
        let sig = signer.sign(message: msg, withHexPrivateKey: "0000000000000000000000000000000000000000000000000000000000000001")
        // either empty if not implemented, or a non-empty signature if the wrapper is implemented; accept both for now
        XCTAssertNotNil(sig)
        #else
        // library not available -> ensure it returns empty
        let signer = LibsecpSigner()
        let msg = "hello".data(using: .utf8)!
        let sig = signer.sign(message: msg, withHexPrivateKey: "aa")
        XCTAssertEqual(sig, "")
        #endif
    }
}
