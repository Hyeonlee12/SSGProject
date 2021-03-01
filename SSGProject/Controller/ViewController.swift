//
//  ViewController.swift
//  SSGProject
//
//  Created by Hyeyeon Lee on 2021/03/01.
//

import UIKit

class ViewController: UIViewController {
	
	// MARK: - Properties
	private var items = [Item]()
	private var searchItems = [SearchItem]()
	private var nextPageToken: String?
	private var searchNextPageToken: String?
	private var nowPlaying: YTPlayerView?
	private var isSearching: Bool = false
	private var expandedCell: [String: Bool] = [:]
	
	private let reuseIdentifier = "VideoCell"
	
	private let searchBar: UISearchBar = {
		let searchbar = UISearchBar()
		searchbar.placeholder = "검색"
		return searchbar
	}()
	
	private let videoCollectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .vertical
		flowLayout.minimumLineSpacing = 20
		let collectionView = UICollectionView(frame: .zero,
																					collectionViewLayout: flowLayout)
		collectionView.allowsSelection = true
		collectionView.backgroundColor = .white
		return collectionView
	}()
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureUI()
		getVideoLists()
	}
	
	// MARK: - Helpers
	func configureUI() {
		view.addSubview(searchBar)
		searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor,
										 left: view.safeAreaLayoutGuide.leftAnchor,
										 right: view.safeAreaLayoutGuide.rightAnchor)
		searchBar.delegate = self
		
		view.addSubview(videoCollectionView)
		videoCollectionView.anchor(top: searchBar.bottomAnchor,
															 left: view.safeAreaLayoutGuide.leftAnchor,
															 bottom: view.safeAreaLayoutGuide.bottomAnchor,
															 right: view.safeAreaLayoutGuide.rightAnchor)
		
		videoCollectionView.register(VideoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		videoCollectionView.dataSource = self
		videoCollectionView.delegate = self
		
	}
	
	func getVideoLists() {
		ApiService.getList(nextPageToken: nextPageToken) { list, error in
			if let error = error {
				print("ERROR: \(error)")
				let alert = UIAlertController(title: "실패", message: "잠시 후에 다시 시도해 주세요.", preferredStyle: .alert)
				let button = UIAlertAction(title: "OK", style: .default, handler: nil)
				alert.addAction(button)
				
				self.present(alert, animated: true, completion: nil)
			}
			if let list = list {
				self.items.append(contentsOf: list.items)
				self.nextPageToken = list.nextPageToken
				DispatchQueue.main.async {
					self.videoCollectionView.reloadData()
				}
			}
		}
	}
	
	func searchLists(searchText: String) {
		ApiService.searchList(searchText: searchText, nextPageToken: searchNextPageToken) { list, error in
			if let error = error {
				print("ERROR: \(error)")
				let alert = UIAlertController(title: "실패", message: "잠시 후에 다시 시도해 주세요.", preferredStyle: .alert)
				let button = UIAlertAction(title: "OK", style: .default, handler: nil)
				alert.addAction(button)
				
				self.present(alert, animated: true, completion: nil)
			}
			if let list = list {
				self.searchItems.append(contentsOf: list.items)
				self.searchNextPageToken = list.nextPageToken
				DispatchQueue.main.async {
					self.videoCollectionView.reloadData()
				}
			}
		}
	}
}

// MARK: - UISearchBarDelegate Extension

extension ViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		searchBar.showsCancelButton = true
		if let cancelButton : UIButton = searchBar.value(forKey: "cancelButton") as? UIButton{
			cancelButton.isEnabled = true
		}
		isSearching = true
		searchItems = []
		if let searchText = searchBar.text {
			videoCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
			searchLists(searchText: searchText)
		}
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		searchBar.text = ""
		searchBar.showsCancelButton = false
		isSearching = false
		searchItems = []
		videoCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top
																		 , animated: false)
		videoCollectionView.reloadData()
	}
}

// MARK: - UICollectionViewDataSource Extension

extension ViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return isSearching ? searchItems.count : items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VideoCell
		cell.backgroundColor = .white
		cell.videoStateDelegate = self
		cell.descriptionDelegate = self
		let video = isSearching ? Video(item: searchItems[indexPath.row]) : Video(item: items[indexPath.row])
		if expandedCell[video.id] != nil {
			cell.expand = expandedCell[video.id]!
		}
		cell.video = video
		cell.indexPath = indexPath
		cell.layoutIfNeeded()
		return cell
	}
}

// MARK: - UICollectionViewDelegate Extension

extension ViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if !isSearching, indexPath.item == items.count - 1, let _ = nextPageToken {
			getVideoLists()
		}
		
		if isSearching, indexPath.item == searchItems.count - 1, let _ = nextPageToken {
			searchLists(searchText: searchBar.text!)
		}
	}
}

// MARK: - UICollectionViewDelegateFlowLayout Extension

extension ViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let video = isSearching ? Video(item: searchItems[indexPath.row]) : Video(item: items[indexPath.row])
		let width = view.frame.width
		let estimatedHeight = view.frame.height
		let dummyCell = VideoCell(frame: CGRect(x: 0, y: 0, width: width, height: estimatedHeight))
		if expandedCell[video.id] != nil {
			dummyCell.expand = expandedCell[video.id]!
		}
		dummyCell.video = video
		dummyCell.layoutIfNeeded()
		let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: width, height: estimatedHeight))
		return CGSize(width: width, height: estimatedSize.height)
	}
}

// MARK: - VideoStateDelegate Extension

extension ViewController: VideoStateDelegate {
	func tapToPlay(playerView: YTPlayerView) {
		if let nowPlaying = nowPlaying {
			nowPlaying.stopVideo()
		}
		nowPlaying = playerView
	}
	
	func notPlaying(playerView: YTPlayerView) {
		if let _ = nowPlaying {
			nowPlaying = nil
		}
	}
}

// MARK: - DescriptionDelegate Extension

extension ViewController: DescriptionDelegate {
	func handleMore(expand: Bool, indexPath: IndexPath, id: String) {
		expandedCell[id] = expand
		videoCollectionView.reloadItems(at: [indexPath])
	}
}
