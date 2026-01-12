import XCTest
@testable import Wallet

final class LibsecpSignerIntegrationTests: XCTestCase {
    func testSigningWhenLibAvailable() throws {
        #if canImport(secp256k1)
        let signer = LibsecpSigner()
        let msg = "test-message".data(using: .utf8)!
        let sig = signer.sign(message: msg, withHexPrivateKey: "0000000000000000000000000000000000000000000000000000000000000001")
        XCTAssertFalse(sig.isEmpty, "Signature should not be empty when secp256k1 is available and properly linked")
        XCTAssertEqual(sig.count % 2, 0) // must be even-length hex
        XCTAssertTrue(sig.count >= 128)
        #else
        // If lib isn't available, just skip
        throw XCTSkip("secp256k1 library not available; skipping integration test")
        #endif
    }
}
