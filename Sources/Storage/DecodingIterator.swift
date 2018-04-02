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
