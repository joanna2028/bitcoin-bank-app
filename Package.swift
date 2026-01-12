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
        // Secp256k1 Swift wrapper (uncomment to enable). Common options:
        .package(url: "https://github.com/awnumar/secp256k1.swift", from: "0.1.0"),
        // Alternative: .package(url: "https://github.com/GigaBitcoin/secp256k1.swift.git", from: "0.1.0"),
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
                // When the secp256k1 SPM package is enabled above, link the product below (module name may vary by package):
                .product(name: "secp256k1", package: "secp256k1.swift", condition: .when(platforms: [.iOS]))
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
