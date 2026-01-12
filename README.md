# bitcoin-bank-app

Bitcoin Bank — a non-custodial Bitcoin wallet and Nostr-enabled payments app (iOS).

Goals:
- Non-custodial wallet (BIP39 seed, native segwit)
- Lightning support for fast, low-fee payments
- Nostr protocol integration for pay requests and social/payment messaging
- No fiat, no KYC/AML

This repository contains an initial SwiftUI scaffold with module skeletons for Wallet, Nostr, and Lightning.

Getting started:
1. Open the project in Xcode (use `swift package generate-xcodeproj` or open the Package.swift directly in Xcode 14+).
2. Enable the secp256k1 dependency in `Package.swift` (an example package is already added). If you uncomment it or change the package, ensure the `Wallet` target links the product (module name may vary by package).

macOS (recommended) quick build & test:
- Install libsecp256k1 if you prefer building against system library: `brew install libsecp256k1` (Optional; many Swift wrappers vend or build the C library themselves).
- Open in Xcode or run tests via Terminal: `swift test` (requires Swift toolchain installed).

Linux quick build & test (dev container):
- Install Swift toolchain (see swift.org for platform-specific packages).
- Install libsecp256k1 (Ubuntu example):
  - `sudo apt-get install -y autoconf automake build-essential libtool pkg-config`
  - `git clone https://github.com/bitcoin-core/secp256k1.git && ./autogen.sh && ./configure --enable-module-ext && make && sudo make install`
- Run `swift test`.

If you do not enable the secp256k1 SPM package, the `LibsecpSigner` will compile but return empty signatures; tests that require the library will be skipped.

Security:
- Keep your seed phrase private and backed up.
- Prefer Secure Enclave-backed key storage where available.

License: MIT
