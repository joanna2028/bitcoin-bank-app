# Architecture

This document outlines the planned architecture for the Bitcoin Bank app.

Modules:
- App (SwiftUI): UI and UX
- Wallet: Mnemonic, key derivation, address derivation, PSBT building
- Nostr: Relay management, event publishing/receiving, pay request handling
- Lightning: Provider interface and integrations (lnd-mobile, remote node, etc.)

Security principles:
- Non-custodial by default
- All sensitive secrets stored securely in Keychain / Secure Enclave
- No telemetry, minimal network dependency

Next steps:
- Choose crypto libraries for BIP39/BIP32 and secp256k1 (recommend adding a libsecp256k1 Swift wrapper and a BIP39 library via SPM)
- Decide Lightning implementation strategy
- Implement end-to-end tests for key flows
- Implement a proper secp256k1 signer and replace the `SoftwareSecp256k1Signer` placeholder in `WalletManager`
- Recommended SPM candidate: `https://github.com/GigaBitcoin/secp256k1.swift` (example). After choosing a library, add it to `Package.swift` and update `LibsecpSigner` to call the library's sign APIs.
