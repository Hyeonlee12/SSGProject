//
//  VideoCell.swift
//  SSGProject
//
//  Created by Hyeyeon Lee on 2021/03/01.
//

import UIKit

protocol VideoStateDelegate: class {
	func tapToPlay(playerView: YTPlayerView)
	func notPlaying(playerView: YTPlayerView)
}

protocol DescriptionDelegate: class {
	func handleMore(height: CGFloat)
}

class VideoCell: UICollectionViewCell {
	
	// MARK: - Properties
	
	weak var videoStateDelegate: VideoStateDelegate?
	weak var descriptionDelegate: DescriptionDelegate?
	var video: Video? {
		didSet { configure() }
	}
	
	private let videoView = YTPlayerView()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "title title title"
		label.lineBreakMode = .byTruncatingTail
		label.setContentHuggingPriority(.defaultHigh, for: .vertical)
		
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
//		label.setContentHuggingPriority(.defaultLow, for: .vertical)
		label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
		
		return label
	}()
	
	private let moreButton: UIButton = {
		let button = UIButton()
		button.setTitle("더보기 >", for: .normal)
		button.backgroundColor = .lightGray
		button.setHeight(height: 30)
		button.setTitleColor(.black, for: .normal)
		
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
		videoView.delegate = self
		
		addSubview(publishedAtLabel)
		publishedAtLabel.anchor(top: videoView.bottomAnchor, right: rightAnchor,
														paddingTop: 10, paddingRight: 10)
		
		addSubview(titleLabel)
		titleLabel.anchor(top: videoView.bottomAnchor, left: leftAnchor,
											paddingTop: 10, paddingLeft: 10)
		titleLabel.rightAnchor.constraint(lessThanOrEqualTo: publishedAtLabel.leftAnchor,
																			constant: -10).isActive = true
		
		addSubview(descriptionLabel)
		descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,
														paddingTop: 10, paddingLeft: 10, paddingRight: 10)
		
		addSubview(moreButton)
		moreButton.anchor(top: descriptionLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,
											paddingTop: 10)
		moreButton.addTarget(self, action: #selector(handleMoreButton(_:)), for: .touchUpInside)
	}
	
	func configure() {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		let date = dateFormatter.date(from: video!.publishedAt)
		
		let dateFormatterPrint = DateFormatter()
		dateFormatterPrint.dateFormat = "yy/MM/dd"
		
		titleLabel.text = video?.title
		publishedAtLabel.text = dateFormatterPrint.string(from: date!)
		descriptionLabel.text = video?.description
		
//		videoView.setHeight(height: frame.width * CGFloat(video?.ratio ?? 3/4))
		videoView.load(withVideoId: video!.id, playerVars: ["playsinline": 1])
	}
	
	// MARK: - Selectors
	
	@objc func handleMoreButton(_ sender: UIButton) {
		descriptionLabel.numberOfLines = 0
		self.descriptionDelegate?.handleMore(height: descriptionLabel.frame.height)
	}
}

extension VideoCell: YTPlayerViewDelegate {
	
	func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
		switch state {
		case .buffering:
			self.videoStateDelegate?.tapToPlay(playerView: playerView)
		case .ended, .paused:
			self.videoStateDelegate?.notPlaying(playerView: playerView)
		default:
			break
		}
	}
}
