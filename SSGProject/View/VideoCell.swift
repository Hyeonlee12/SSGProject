//
//  VideoCell.swift
//  SSGProject
//
//  Created by Hyeyeon Lee on 2021/03/01.
//

import UIKit

class VideoCell: UICollectionViewCell {
	
	// MARK: - Properties
	
	private let videoView = YTPlayerView()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "title title title"
		label.lineBreakMode = .byTruncatingTail
		
		return label
	}()
	
	private let publishedAtLabel: UILabel = {
		let label = UILabel()
		label.text = "publishedAt"
		
		return label
	}()
	
	private let descriptionLabel: UILabel = {
		let label = UILabel()
		label.text = "description description description description description description description description description description description description description description "
		label.numberOfLines = 2
		
		return label
	}()
	
	private let moreButton: UIButton = {
		let button = UIButton()
		button.setTitle("더보기 >", for: .normal)
		button.backgroundColor = .lightGray
		button.setTitleColor(.black, for: .normal)
		button.addTarget(self, action: #selector(handleMoreButton), for: .touchUpInside)
		
		return button
	}()
	
	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configureUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Helpers
	
	func configureUI() {
		addSubview(videoView)
		videoView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
		
		addSubview(publishedAtLabel)
		publishedAtLabel.anchor(top: videoView.bottomAnchor, right: rightAnchor,
														paddingTop: 10, paddingRight: 10)
		
		addSubview(titleLabel)
		titleLabel.anchor(top: videoView.bottomAnchor, left: leftAnchor, right: publishedAtLabel.leftAnchor,
											paddingTop: 10, paddingLeft: 10, paddingRight: 10)
		
		addSubview(descriptionLabel)
		descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,
														paddingTop: 10, paddingLeft: 10, paddingRight: 10)
		
		addSubview(moreButton)
		moreButton.anchor(top: descriptionLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,
											paddingTop: 10)
	}
	
	// MARK: - Selectors
	
	@objc func handleMoreButton(_ sender: UIButton) {
//		if descriptionLabel.numberOfLines == 2 {
//			descriptionLabel.numberOfLines = 0
//			sender.setTitle("접기 <", for: .normal)
//		} else {
//			descriptionLabel.numberOfLines = 2
//			sender.setTitle("더보기 >", for: .normal)
//		}
	}
}
