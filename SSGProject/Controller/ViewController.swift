//
//  ViewController.swift
//  SSGProject
//
//  Created by Hyeyeon Lee on 2021/03/01.
//

import UIKit

class ViewController: UIViewController {

	// MARK: - Properties
	
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
		collectionView.allowsSelection = false
		collectionView.backgroundColor = .white
		return collectionView
	}()

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureUI()
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
		return 5
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VideoCell
		cell.backgroundColor = .white
		return cell
	}
}

// MARK: - UICollectionViewDelegate Extension
extension ViewController: UICollectionViewDelegate {
	
}

extension ViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

//		let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
//		let estimatedSizeCell = VideoCell(frame: frame)
////		estimatedSizeCell.message = messages[indexPath.row]
//		estimatedSizeCell.layoutIfNeeded()
//
//		let targetSize = CGSize(width: view.frame.width, height: 1000)
//		let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
//
		return CGSize(width: view.frame.width, height: 300)
	}
}
