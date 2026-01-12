// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "BitcoinBankApp",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "BitcoinBankApp", targets: ["App"]),
    ],
    dependencies: [
        // NOTE: secp256k1 Swift wrapper disabled in CI to avoid network fetch issues in this environment.
        // Uncomment one of the following package lines to enable a specific SPM wrapper for secp256k1.
        // .package(url: "https://github.com/awnumar/secp256k1.swift", from: "0.1.0"),
        // .package(url: "https://github.com/GigaBitcoin/secp256k1.swift.git", from: "0.1.0"),
    ],

    targets: [
        .target(
            name: "App",
            dependencies: [
                // Nostr, Wallet, Lightning targets will be linked here
            ],
            path: "Sources/App"
        ),
        .target(
            name: "Nostr",
            path: "Sources/Nostr"
        ),
        .target(
            name: "Wallet",
            dependencies: [
                // Add secp256k1 product here when an SPM wrapper has been enabled in dependencies
            ],
            path: "Sources/Wallet"
        ),
        .target(
            name: "Lightning",
            path: "Sources/Lightning"
        ),
        .testTarget(
            name: "BitcoinBankAppTests",
            dependencies: ["App"],
            path: "Tests"
        )
    ]
)
