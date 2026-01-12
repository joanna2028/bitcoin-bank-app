# bitcoin-bank-app

Bitcoin Bank — a non-custodial Bitcoin wallet and Nostr-enabled payments app (iOS).

Goals:
- Non-custodial wallet (BIP39 seed, native segwit)
- Lightning support for fast, low-fee payments
- Nostr protocol integration for pay requests and social/payment messaging
- No fiat, no KYC/AML

This repository contains an initial SwiftUI scaffold with module skeletons for Wallet, Nostr, and Lightning.

Getting started:
1. Open the project in Xcode (add an Xcode project or use `swift package generate-xcodeproj` to generate one).
2. Add crypto dependencies (secp256k1 / libwally / BitcoinKit) and a Lightning provider (lnd-mobile or remote provider) via Swift Package Manager.
3. Implement the TODOs in the `Sources/Wallet`, `Sources/Nostr`, and `Sources/Lightning` modules.

Security:
- Keep your seed phrase private and backed up.
- Prefer Secure Enclave-backed key storage where available.

License: MIT
