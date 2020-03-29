// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Storage",
    products: [
        .library(name: "Server", targets: ["Server"]),
        .library(name: "Storage", targets: ["Storage"]),
    ],
    dependencies: [
        .package(path: "../async"),
        .package(path: "../time"),
        .package(path: "../aio"),
        .package(path: "../json"),
        .package(path: "../messagepack"),
        .package(path: "../fiber"),
        .package(path: "../http"),
        .package(path: "../log"),
        .package(path: "../test")
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
