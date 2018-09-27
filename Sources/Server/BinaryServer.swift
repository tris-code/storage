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

import Log
import File
import Async
import Stream
import Network
import MessagePack

final class BinaryServer {
    var server: Network.Server
    var storage: SharedStorage

    init(for storage: SharedStorage, at host: String, on port: Int) throws {
        self.storage = storage
        self.server = try Network.Server(host: host, port: port)
        self.server.onClient = binaryHandler
        self.server.onError = onError
    }

    convenience
    init(for storage: Storage, at host: String, on port: Int) throws {
        try self.init(for: .init(for: storage), at: host, on: port)
    }

    func binaryHandler(_ socket: Socket) {
        do {
            let stream = NetworkStream(socket: socket)
            let input = BufferedInputStream(
                baseStream: stream,
                capacity: 4096,
                expandable: true)
            let output = BufferedOutputStream(baseStream: stream)
            try handleBinaryConnection(input: input, output: output)
        } catch {
            onError(error)
        }
    }

    func handleBinaryConnection(
        input: StreamReader,
        output: StreamWriter) throws
    {
        while try input.cache(count: 1) {
            let request = try BinaryProtocol.Request(from: input)
            let response = handle(request)
            try response.encode(to: output)
        }
        try output.flush()
    }

    func handle(_ request: BinaryProtocol.Request) -> BinaryProtocol.Response {
        do {
            switch request {
            case .rpc(let function, let arguments):
                let result = try storage.call(function, with: arguments)
                switch result {
                case .some(let result):
                    return .output({ writer in
                        try MessagePack.encode(encodable: result, to: writer)
                    })
                case .none:
                    return .error(.functionNotFound)
                }
            }
        } catch {
            return .error(.unknown)
        }
    }

    func start() throws {
        try server.start()
    }

    func onError(_ error: Swift.Error) {
        Log.critical(String(describing: error))
    }
}