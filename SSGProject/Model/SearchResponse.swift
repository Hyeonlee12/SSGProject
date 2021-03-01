//
//  SearchResponse.swift
//  SSGProject
//
//  Created by Hyeyeon Lee on 2021/03/01.
//

import Foundation

struct SearchResponse: Codable {
	let kind: String
	let etag: String
	let nextPageToken: String?
	let prevPageToken: String?
	let regionCode: String
	let pageInfo: PageInfo
	let items: [SearchItem]
}

struct SearchItem: Codable {
	let kind: String
	let etag: String
	let id: SearchId
	let snippet: Snippet
}

struct SearchId: Codable {
	let kind: String
	let videoId: String
}
