//
//  StubBuilder.swift
//  
//
//  Created by Yuki Okudera on 2022/08/14.
//

import UIKit

enum StubBuilder<T: Decodable> {
    /// JSONファイルからスタブを生成する
    /// - Parameter assetName: Assets.xcassetsのJSONファイル名（拡張子無し）
    /// - Returns: Tのスタブ
    static func build(assetName: String) throws -> T {
        let jsonData = NSDataAsset(name: assetName, bundle: .module)!.data

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: jsonData)
    }
}
