/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import File
import Stream
import MessagePack

final class MessagePackCoder: StreamCoder, StreamAnyDecoder {
    var typeAccessor: TypeAccessor

    init(typeAccessor: @escaping TypeAccessor) {
        self.typeAccessor = typeAccessor
    }

    func next<T: AnyDecodable>(from reader: StreamReader) throws -> T? {
        do {
            let messagePack = try MessagePack.decode(from: reader)
            let decoder = MessagePackDecoder(messagePack)
            return try T(from: decoder, typeAccessor: typeAccessor)
        } catch let error as StreamError where error == .insufficientData {
            return nil
        }
    }

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
