//
//  ApiService.swift
//  SSGProject
//
//  Created by Hyeyeon Lee on 2021/03/01.
//

import Foundation

struct ApiService {
	static func getList(nextPageToken: String?, completion: @escaping (ListResponse?, String?) -> Void) {
		var urlComponent = URLComponents(string: "\(API_URL)/videos")
		
		urlComponent?.queryItems = [
			URLQueryItem(name: "part", value: "snippet"),
			URLQueryItem(name: "key", value: API_KEY),
			URLQueryItem(name: "chart", value: "mostPopular"),
			URLQueryItem(name: "regionCode", value: "kr")
		]
		
		if let nextPageToken = nextPageToken {
			urlComponent?.queryItems?.append(URLQueryItem(name: "pageToken", value: nextPageToken))
		}
		
		guard let url = urlComponent?.url else {
			completion(nil, "URL Not Supported")
			return
		}
		print(url)
		
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = "GET"
		urlRequest.timeoutInterval = TimeInterval(10)
		
		URLSession.shared.dataTask(with: urlRequest) { data, response, error in
			if let error = error {
				completion(nil, error.localizedDescription)
			}
			
			if let response = response as? HTTPURLResponse,
				 (200..<300).contains(response.statusCode), let data = data {
				
				do {
					let response = try JSONDecoder().decode(ListResponse.self, from: data)
					print("response: \(response)")
					completion(response, nil)
				} catch {
					completion(nil, error.localizedDescription)
				}
				
			}
		}.resume()
	}
	
	static func searchList(searchText: String, nextPageToken: String?, completion: @escaping (SearchResponse?, String?) -> Void) {
		var urlComponent = URLComponents(string: "\(API_URL)/search")
		
		urlComponent?.queryItems = [
			URLQueryItem(name: "part", value: "snippet"),
			URLQueryItem(name: "key", value: API_KEY),
			URLQueryItem(name: "q", value: searchText),
			URLQueryItem(name: "type", value: "video"),
			URLQueryItem(name: "regionCode", value: "kr")
		]
		
		if let nextPageToken = nextPageToken {
			urlComponent?.queryItems?.append(URLQueryItem(name: "pageToken", value: nextPageToken))
		}
		
		guard let url = urlComponent?.url else {
			completion(nil, "URL Not Supported")
			return
		}
		print(url)
		
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = "GET"
		urlRequest.timeoutInterval = TimeInterval(10)
		
		URLSession.shared.dataTask(with: urlRequest) { data, response, error in
			if let error = error {
				completion(nil, error.localizedDescription)
			}
			
			if let response = response as? HTTPURLResponse,
				 (200..<300).contains(response.statusCode), let data = data {
				
				do {
					let response = try JSONDecoder().decode(SearchResponse.self, from: data)
					print("response: \(response)")
					completion(response, nil)
				} catch {
					completion(nil, error.localizedDescription)
				}
				
			}
		}.resume()
	}
}
