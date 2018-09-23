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
import HTTP
import Async

final class HTTPServer {
    var server: HTTP.Server
    var storage: SharedStorage

    init(for storage: SharedStorage, at host: String, on port: Int) throws {
        self.storage = storage
        self.server = try HTTP.Server(host: host, port: port)
        self.server.route(get: "/call/:string", to: httpHandler)
    }

    convenience
    init(for storage: Storage, at host: String, on port: Int) throws {
        try self.init(for: .init(for: storage), at: host, on: port)
    }

    func httpHandler(
        request: Request,
        function: String) throws -> Response
    {
        let arguments = request.url.query?.values ?? [:]
        guard let result = try storage.call(function, with: arguments) else {
            throw HTTP.Error.notFound
        }
        return try Response(body: result)
    }

    func start() throws {
        try server.start()
    }

    func onError(_ error: Swift.Error) {
        Log.critical(String(describing: error))
    }
}
