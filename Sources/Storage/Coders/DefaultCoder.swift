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

typealias DefaultCoder = JsonCoder

extension Storage {
    convenience
    public init(at path: Path) throws {
        try self.init(at: path, coder: DefaultCoder.self)
    }
}
