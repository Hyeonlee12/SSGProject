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
	private var nowPlaying: YTPlayerView?
	
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
}

extension ViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		searchBar.showsCancelButton = true
		if let cancelButton : UIButton = searchBar.value(forKey: "cancelButton") as? UIButton{
			cancelButton.isEnabled = true
		}
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		searchBar.text = ""
		searchBar.showsCancelButton = false
	}
}

// MARK: - UICollectionViewDataSource Extension
extension ViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VideoCell
		cell.backgroundColor = .white
		cell.videoStateDelegate = self
		cell.descriptionDelegate = self
		cell.video = Video(item: items[indexPath.row])
		cell.layoutIfNeeded()
		return cell
	}
}

// MARK: - UICollectionViewDelegate Extension
extension ViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if indexPath.item == items.count - 1, let _ = nextPageToken {
			getVideoLists()
		}
	}
}

// MARK: - UICollectionViewDelegateFlowLayout Extension
extension ViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let video = Video(item: items[indexPath.row])
		return .init(width: view.frame.width, height: view.frame.width * video.ratio + 120)
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
	func handleMore(height: CGFloat) {
		videoCollectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
	}
}
