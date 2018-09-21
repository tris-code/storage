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
import MessagePack

final class MessagePackCoder: StreamCoder {
    func next<T: Decodable>(
        _ type: T.Type,
        from reader: StreamReader) throws -> T?
    {
        do {
            return try MessagePack.decode(type, from: reader)
        } catch let error as StreamError where error == .insufficientData {
            return nil
        }
    }

    func next(
        _ type: Decodable.Type,
        from reader: StreamReader) throws -> Decodable?
    {
        do {
            return try MessagePack.decode(decodable: type, from: reader)
        } catch let error as StreamError where error == .insufficientData {
            return nil
        }
    }

    func write(_ record: Encodable, to writer: StreamWriter) throws {
        try MessagePack.encode(encodable: record, to: writer)    }
}
