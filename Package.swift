// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Storage",
    products: [
        .library(name: "Server", targets: ["Server"]),
        .library(name: "Storage", targets: ["Storage"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/tris-code/async.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-code/time.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-code/aio.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-code/json.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-code/messagepack.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-code/fiber.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-code/http.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-code/log.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-code/test.git",
            .branch("master"))
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
