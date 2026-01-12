import Foundation

/// Wallet manager skeleton for non-custodial Bitcoin wallet.
/// - Mnemonic (BIP39) generation/import
/// - Key derivation (BIP32/BIP84)
/// - Secure storage (Keychain / Secure Enclave)
/// TODO: Integrate a battle-tested crypto library (libsecp256k1 / libwally / BitcoinKit)
public protocol Secp256k1Signer {
    /// Sign the provided message (bytes) returning compact hex signature (64 bytes) or empty string if not implemented
    func sign(message: Data, withHexPrivateKey hexPriv: String) -> String
}

public final class WalletManager {
    public static let shared = WalletManager()

    // injectable signer (default is a placeholder that must be replaced by a concrete implementation)
    public var signer: Secp256k1Signer = SoftwareSecp256k1Signer()

    private init() {}

    // MARK: - Mnemonic

    public func generateMnemonic(strength: Int = 256) -> String {
        // TODO: Use BIP39 library
        return "" // mnemonic words
    }

    public func importMnemonic(_ mnemonic: String) throws {
        // TODO: validate & derive seed
    }

    // MARK: - Key storage

    public func storeSeedEncrypted(_ seed: Data, passphrase: String?) throws {
        // Use Keychain and Secure Enclave for encryption and storage
    }

    public func loadSeed() throws -> Data {
        // TODO: implement
        return Data()
    }

    // MARK: - Addresses & transactions

    public func getReceivingAddress() throws -> String {
        // TODO: derive bech32 native segwit address
        return "bc1..."
    }

    public func createOnchainTransaction(to address: String, amountSats: UInt64, feeSatsPerVByte: UInt64) throws -> Data {
        // TODO: Build PSBT / raw tx
        return Data()
    }

    // MARK: - Nostr signing adapter

    /// Sign a Nostr event using the configured Secp256k1Signer.
    /// This constructs the canonical Nostr serialization and delegates signing to the injected signer.
    public func signNostrEvent(event: NostrEvent, hexPrivateKey: String) -> String {
        do {
            let serialized = try event.serializedForSigning()
            // signer is expected to compute SHA256 and sign the digest (or accept raw bytes and handle hashing internally)
            return signer.sign(message: serialized, withHexPrivateKey: hexPrivateKey)
        } catch {
            print("Failed to serialize event for signing: \(error)")
            return ""
        }
    }
}

// Placeholder software signer. Replace with a real secp256k1-backed implementation (e.g., via libsecp256k1 Swift wrapper) before production.
public struct SoftwareSecp256k1Signer: Secp256k1Signer {
    public init() {}
    public func sign(message: Data, withHexPrivateKey hexPriv: String) -> String {
        // TODO: integrate a proper secp256k1 signing implementation. Returning empty string for now.
        return ""
    }
}
