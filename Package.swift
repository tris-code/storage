// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Storage",
    products: [
        .library(name: "Server", targets: ["Server"]),
        .library(name: "Storage", targets: ["Storage"]),
    ],
    dependencies: [
        .package(path: "../Async"),
        .package(path: "../Time"),
        .package(path: "../AIO"),
        .package(path: "../JSON"),
        .package(path: "../MessagePack"),
        .package(path: "../Fiber"),
        .package(path: "../HTTP"),
        .package(path: "../Log"),
        .package(path: "../Test")
    ],
    targets: [
        .target(
            name: "Server",
            dependencies: [
                "Storage",
                "Time",
                "File",
                "Log",
                "HTTP",
                "MessagePack"
            ]),
        .target(
            name: "Storage",
            dependencies: [
                "Async",
                "Fiber",
                "File",
                "Time",
                "JSON",
                "MessagePack"
            ]),
        .testTarget(
            name: "StorageServerTests",
            dependencies: ["Test", "Server", "Fiber"]),
        .testTarget(
            name: "StorageTests",
            dependencies: ["Test", "Storage"]),
    ]
)
