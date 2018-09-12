// swift-tools-version:4.2
/******************************************************************************
 *                                                                            *
 * Tris Foundation disclaims copyright to this source code.                   *
 * In place of a legal notice, here is a blessing:                            *
 *                                                                            *
 *     May you do good and not evil.                                          *
 *     May you find forgiveness for yourself and forgive others.              *
 *     May you share freely, never taking more than you give.                 *
 *                                                                            *
 ******************************************************************************/

import PackageDescription

let package = Package(
    name: "Storage",
    products: [
        .library(name: "Server", targets: ["Server"]),
        .library(name: "Storage", targets: ["Storage"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/tris-foundation/async.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/time.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/aio.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/json.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/messagepack.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/fiber.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/http.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/log.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/test.git",
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
