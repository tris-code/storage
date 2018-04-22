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

import File
import Stream

class DecodingIterator<T: AnyDecodable>: IteratorProtocol {
    let decoder: StreamAnyDecoder
    let source: StreamReader

    init(from file: File, using decoder: StreamAnyDecoder) throws {
        self.decoder = decoder
        self.source = try file.open(flags: [.read]).inputStream
    }

    func next() -> T? {
        do {
            return try decoder.next(from: source)
        } catch {
            return nil
        }
    }
}
