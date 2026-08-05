// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Kukuda",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "Kukuda", targets: ["KiwiBreak"])
    ],
    targets: [
        .executableTarget(name: "KiwiBreak"),
        .testTarget(name: "KiwiBreakTests", dependencies: ["KiwiBreak"])
    ]
)
