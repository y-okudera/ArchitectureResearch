//
//  GitHubRepoItemView.swift
//
//
//  Created by Yuki Okudera on 2022/09/19.
//

import Kingfisher
import Models
import SwiftUI

#warning("Will modularize")

// MARK: - GitHubRepoItemView
public struct GitHubRepoItemView: View {
    let gitHubRepo: GitHubRepo

    public init(gitHubRepo: GitHubRepo) {
        self.gitHubRepo = gitHubRepo
    }

    public var body: some View {
        HStack(alignment: .center, spacing: 16.0) {
            Spacer()
                .frame(width: 16.0)
            KFImage(gitHubRepo.owner.avatarUrl)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35.0, height: 35.0)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 0) {
                Text(gitHubRepo.fullName)
                    .font(.headline)
                    .lineLimit(1)
                Text(gitHubRepo.description ?? "")
                    .font(.subheadline)
                    .lineLimit(1)
            }
            Spacer()
        }
    }
}

// MARK: - GitHubRepoItemView_Previews
struct GitHubRepoItemView_Previews: PreviewProvider {
    static var previews: some View {
        GitHubRepoItemView(gitHubRepo: .mock)
    }
}
