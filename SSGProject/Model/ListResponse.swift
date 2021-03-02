//
//  ListResponse.swift
//  SSGProject
//
//  Created by Hyeyeon Lee on 2021/03/01.
//

import Foundation

struct ListResponse: Codable {
	let kind: String
	let etag: String
	let nextPageToken: String?
	let prevPageToken: String?
	let pageInfo: PageInfo
	let items: [Item]
}

struct PageInfo: Codable {
	let totalResults: Int
	let resultsPerPage: Int
}

struct Item: Codable {
	let kind: String
	let etag: String
	let id: String
	let snippet: Snippet
}

struct Snippet: Codable {
	let publishedAt: String
	let channelId: String
	let title: String
	let description: String
	let thumbnails: Thumbnail
	let channelTitle: String
	let tags: [String]?
	let categoryId: String?
	let liveBroadcastContent: String
	let defaultLanguage: String?
	let localized: Localized?
	let defaultAudioLanguage: String?
	let publishTime: String?
}

struct Thumbnail: Codable {
	let `default`: ThumbnailDetail
	let medium: ThumbnailDetail?
	let high: ThumbnailDetail?
	let standard: ThumbnailDetail?
	let maxres: ThumbnailDetail?
}

struct ThumbnailDetail: Codable {
	let url: String
	let width: CGFloat
	let height: CGFloat
}

struct Localized: Codable {
	let title: String
	let description: String
}
