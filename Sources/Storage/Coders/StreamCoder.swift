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

import Stream

public protocol StreamEncoder {
    func write<T>(_ action: T, to writer: StreamWriter) throws
        where T: Encodable
}

public protocol StreamDecoder {
    func next<T>(_ type: T.Type, from reader: StreamReader) throws -> T?
        where T: Decodable
}

public  protocol StreamCoder: StreamEncoder & StreamDecoder {}
