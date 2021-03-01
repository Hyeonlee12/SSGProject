//
//  Video.swift
//  SSGProject
//
//  Created by Hyeyeon Lee on 2021/03/01.
//

import Foundation

struct Video {
	let id: String
	let publishedAt: String
	let title: String
	let description: String
	let ratio: CGFloat
	
	init(item: Item) {
		self.id = item.id
		self.publishedAt = item.snippet.publishedAt
		self.title = item.snippet.title
		self.description = item.snippet.description
		if let maxres = item.snippet.thumbnails.maxres {
			self.ratio = CGFloat(maxres.height / maxres.width)
		} else if let standard = item.snippet.thumbnails.standard {
			self.ratio = CGFloat(standard.height / standard.width)
		} else if let high = item.snippet.thumbnails.high {
			self.ratio = CGFloat(high.height / high.width)
		} else if let medium = item.snippet.thumbnails.medium {
			self.ratio = CGFloat(medium.height / medium.width)
		} else {
			self.ratio = CGFloat(item.snippet.thumbnails.default.height / item.snippet.thumbnails.default.width)
		}
		
	}
	
	init(item: SearchItem) {
		self.id = item.id.videoId
		self.publishedAt = item.snippet.publishedAt
		self.title = item.snippet.title
		self.description = item.snippet.description
		if let maxres = item.snippet.thumbnails.maxres {
			self.ratio = CGFloat(maxres.height / maxres.width)
		} else if let standard = item.snippet.thumbnails.standard {
			self.ratio = CGFloat(standard.height / standard.width)
		} else if let high = item.snippet.thumbnails.high {
			self.ratio = CGFloat(high.height / high.width)
		} else if let medium = item.snippet.thumbnails.medium {
			self.ratio = CGFloat(medium.height / medium.width)
		} else {
			self.ratio = CGFloat(item.snippet.thumbnails.default.height / item.snippet.thumbnails.default.width)
		}
	}
}
