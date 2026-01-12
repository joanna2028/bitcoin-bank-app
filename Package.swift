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
        // Recommended secp256k1 Swift wrapper (uncomment to enable):
        // .package(url: "https://github.com/GigaBitcoin/secp256k1.swift.git", from: "0.1.0"),
        // Example community alternative (uncomment to enable):
        // .package(url: "https://github.com/awnumar/secp256k1.swift", from: "0.1.0"),
        // When added, also link the product into the Wallet target dependencies (e.g. "secp256k1" or the product provided by the wrapper).
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
