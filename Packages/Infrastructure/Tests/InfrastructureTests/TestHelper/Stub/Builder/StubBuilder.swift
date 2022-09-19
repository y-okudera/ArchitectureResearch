//
//  StubBuilder.swift
//
//
//  Created by Yuki Okudera on 2022/08/14.
//

import Foundation

enum StubBuilder<T: Decodable> {
    /// JSONファイルからスタブを生成する
    /// - Parameters:
    ///   - name: ファイル名
    ///   - ext: 拡張子
    /// - Returns: Tのスタブ
    static func build(forResource name: String, withExtension ext: String?) -> T {
        let jsonUrl = Bundle.module.url(forResource: name, withExtension: ext)!
        let jsonData = try! Data(contentsOf: jsonUrl)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try! decoder.decode(T.self, from: jsonData)
    }
}
