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

struct Snapshot {
    struct Header: Codable {
        let name: Storage.Key
        let count: Int
    }

    class Reader {
        let stream: StreamReader
        let decoder: StreamDecoder

        init(from file: File, decoder: StreamDecoder) throws {
            self.stream = try file.open(flags: .read).inputStream
            self.decoder = decoder
        }

        func readHeader() throws -> Header? {
            return try decoder.next(Header.self, from: stream)
        }

        func readNext(_ type: Decodable.Type) throws -> Decodable? {
            return try decoder.next(type, from: stream)
        }
    }

    class Writer {
        let output: StreamWriter
        let encoder: StreamEncoder

        init(to file: File, encoder: StreamEncoder) throws {
            try file.create()
            let stream = try file.open(flags: [.create, .write]).outputStream
            try stream.seek(to: .end)
            self.output = stream
            self.encoder = encoder
        }

        func write(header: Header) throws {
            try encoder.write(header, to: output)
        }

        func write(_ value: Encodable) throws {
            try encoder.write(value, to: output)
        }

        func flush() throws {
            try output.flush()
        }
    }
}
