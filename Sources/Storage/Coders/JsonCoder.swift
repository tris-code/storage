/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import JSON
import File
import Stream

final class JsonCoder: StreamCoder, StreamAnyDecoder {
    var typeAccessor: TypeAccessor

    init(typeAccessor: @escaping TypeAccessor) {
        self.typeAccessor = typeAccessor
    }

    enum Error: Swift.Error {
        case invalidFormat
    }

    func withScopedDecoder<T>(
        from reader: StreamReader,
        _ body: (Swift.Decoder) throws -> T?) throws -> T?
    {
        do {
            let next = try JSON.withScopedDecoder(using: reader, body)
            guard try reader.consume(.lf) else {
                throw Error.invalidFormat
            }
            return next
        } catch let error as StreamError where error == .insufficientData {
            return nil
        }
    }

    func next<T: AnyDecodable>(from reader: StreamReader) throws -> T? {
        return try withScopedDecoder(from: reader) { decoder in
            return try T(from: decoder, typeAccessor: typeAccessor)
        }
    }

    func next<T: Decodable>(
        _ type: T.Type,
        from reader: StreamReader) throws -> T?
    {
        return try withScopedDecoder(from: reader) { decoder in
            return try T(from: decoder)
        }
    }

    func next(
        _ type: Decodable.Type,
        from reader: StreamReader) throws -> Decodable?
    {
        return try withScopedDecoder(from: reader) { decoder in
            try type.init(from: decoder)
        }
    }

    func write(_ record: Encodable, to writer: StreamWriter) throws {
        try JSON.withScopedEncoder(using: writer) { encoder in
            try record.encode(to: encoder)
        }
        try writer.write(.lf)
    }
}

fileprivate extension UInt8 {
    static let lf = UInt8(ascii: "\n")
}
