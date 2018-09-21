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

extension WAL.Record: Codable {
    enum CodingKeys: CodingKey {
        case action
        case entity
        case key
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let action = try container.decode(Action.self, forKey: .action)
        switch action {
        case .upsert:
            let superDecoder = try container.superDecoder(forKey: .entity)
            let entity = try T(from: superDecoder)
            self = .upsert(entity)
        case .delete:
            let superDecoder = try container.superDecoder(forKey: .key)
            let key = try T.Key(from: superDecoder)
            self = .delete(key)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .upsert(let entity):
            try container.encode(Action.upsert, forKey: .action)
            let superEncoder = container.superEncoder(forKey: .entity)
            try entity.encode(to: superEncoder)
        case .delete(let key):
            try container.encode(Action.delete, forKey: .action)
            let superEncoder = container.superEncoder(forKey: .key)
            try key.encode(to: superEncoder)
        }
    }
}
