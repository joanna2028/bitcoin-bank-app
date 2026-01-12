import Foundation
import CryptoKit

#if canImport(secp256k1)
import secp256k1
#endif

// MARK: - Hex helpers
fileprivate extension Data {
    init?(hex: String) {
        let len = hex.count / 2
        var data = Data(capacity: len)
        var i = hex.startIndex
        for _ in 0..<len {
            let j = hex.index(i, offsetBy: 2)
            let bytes = hex[i..<j]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
            i = j
        }
        self = data
    }

    func hexString() -> String {
        self.map { String(format: "%02x", $0) }.joined()
    }
}

/// Implementation of `Secp256k1Signer` that uses an external secp256k1 library when available.
/// This is a wrapper around the chosen library; specific function calls will need to be adapted to the exact SPM package API.
public struct LibsecpSigner: Secp256k1Signer {
    public init() {}

    public func sign(message: Data, withHexPrivateKey hexPriv: String) -> String {
        guard let priv = Data(hex: hexPriv) else { return "" }

        // Nostr expects the SHA-256 of the serialized event to be signed; accept either the raw bytes or digest.
        let digest = Data(SHA256.hash(data: message))

        #if canImport(secp256k1)
        // If a C-style libsecp256k1 is linked, call its API directly. This uses the standard C function names from libsecp256k1.
        // The exact header and linking depends on the chosen SPM wrapper. These calls are guarded at compile time and will only be compiled when the library is present.
        
        // Context: SECP256K1_CONTEXT_SIGN
        guard let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN)) else { return "" }
        defer { secp256k1_context_destroy(ctx) }

        var recSig = secp256k1_ecdsa_recoverable_signature()

        let ok = digest.withUnsafeBytes { digestPtr -> Int32 in
            return priv.withUnsafeBytes { privPtr -> Int32 in
                return secp256k1_ecdsa_sign_recoverable(ctx, &recSig, digestPtr.baseAddress!.assumingMemoryBound(to: UInt8.self), privPtr.baseAddress!.assumingMemoryBound(to: UInt8.self), nil, nil)
            }
        }

        guard ok == 1 else { return "" }

        var out = [UInt8](repeating: 0, count: 64)
        var recid: Int32 = 0
        let serialOk = secp256k1_ecdsa_recoverable_signature_serialize_compact(ctx, &out, &recid, &recSig)
        guard serialOk == 1 else { return "" }

        return Data(out).hexString()
        #else
        // Library not available at compile-time; return empty to indicate not implemented
        return ""
        #endif
    }
}
