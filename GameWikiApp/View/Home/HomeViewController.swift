//
//  HomeViewController.swift
//  GameWikiApp
//
//  Created by Celil Aydın on 5.02.2023.
//

import Foundation
import UIKit
import Combine
import MBProgressHUD

class HomeViewController: UIViewController, UIAnimatable {
    
    
    @IBOutlet weak var gameCollectionView: UICollectionView!
    
    private let apiService = APIService()
    private var subscribers = Set<AnyCancellable>()
    private var searchResults: SearchResults?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        observeForm()
    }
    
    private func setCollectionView() {
        gameCollectionView.delegate = self
        gameCollectionView.dataSource = self
        title = LocalizableString.HomeScreenTitle.localized
        if let layout = gameCollectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        gameCollectionView.register(.init(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "homeCell")
    }
    
    private func observeForm() {
        showLoadingAnimation()
        apiService.fetchGameNamePublisher(keywords: "").sink { completion in
            self.hideLoadingAnimation()
            switch completion {
            case .failure(let error):
                print(error)
            case .finished:
                break
            }
        } receiveValue: { searchResults in
            self.searchResults = searchResults
            self.gameCollectionView.reloadData()
            print(searchResults)
        }.store(in: &subscribers)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = gameCollectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCollectionViewCell
        if let searchResults = searchResults {
            let searchResult = searchResults.results[indexPath.row]
            cell.configure(with: searchResult)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults?.results.count ?? 0
    }
}
extension HomeViewController : PinterestLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        return 200
    }
    
    func collectionView(collectionView: UICollectionView, heightForCaptionAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        if let post = searchResults?.results[indexPath.item] {
            let captionFont = UIFont.systemFont(ofSize: 20)
            let captionHeight = self.height(for: post.name, with: captionFont, width: width) - 20
            let height = (captionHeight * 2) - 10
            return height
        }
        
        return 0.0
    }
    
    func height(for text: String, with font: UIFont, width: CGFloat) -> CGFloat
    {
        let nsstring = NSString(string: text)
        let maxHeight = CGFloat(70)
        let textAttributes = [NSAttributedString.Key.font : font]
        let boundingRect = nsstring.boundingRect(with: CGSize(width: width, height: maxHeight), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
        return ceil(boundingRect.height)
    }
}
