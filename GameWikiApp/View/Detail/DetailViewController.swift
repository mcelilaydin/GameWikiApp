//
//  DetailViewController.swift
//  GameApp
//
//  Created by Celil Aydın on 6.02.2023.
//

import UIKit
import SCLAlertView
import CoreData
import Combine

class DetailViewController: UIViewController {
    
    private enum Fav {
        case favori
        case notFavori
    }
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var favoriButton: UIButton!

    var asset: Asset?
    var idArray = [Int]()
    private var mode: Fav = .notFavori
    private var subscribers = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setView()
        checkFavoriteGame()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setButtonImage()
    }
    
    private func setView() {
        title = LocalizableString.DetailScreenTitle.localized
        guard let asset = asset else { return }
        titleLabel.text = asset.searchResult.name
        dateLabel.text = asset.gameDetails.released
        descriptionTextView.text = asset.gameDetails.descriptionRaw
    }
    
    private func setCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    
    private func setButtonImage(){
        switch mode {
        case.favori:
            favoriButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        case.notFavori:
            favoriButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    @IBAction func favoriButtonClicked(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newFavorite = NSEntityDescription.insertNewObject(forEntityName: "Favorite", into: context)
            newFavorite.setValue(asset?.searchResult.name, forKey: "name")
            newFavorite.setValue(asset?.searchResult.id, forKey: "id")
            do{
                try context.save()
                print("success")
                SCLAlertView().showSuccess(LocalizableString.Success.localized, subTitle: LocalizableString.AddedFavorite.localized)
            }catch{
                print("error")
            }
            favoriButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            mode = .favori
            NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
    }
    
    private func checkFavoriteGame() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        fetchRequest.returnsObjectsAsFaults = false
        do{
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let id = result.value(forKey: "id") as? Int{
                        idArray.append(id)
                    }
                }
                if let asset = asset {
                    let result = idArray.filter({ $0 == asset.searchResult.id })
                    if result.count != 0 {
                        mode = .favori
                        print("oyun favoride")
                    }else {
                        print("oyun favoride değil")
                        mode = .notFavori
                    }
                }
            }
        }catch{
            print("error")
        }
    }
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return asset?.searchResult.shortScreenshots.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.identifier, for: indexPath) as! DetailCollectionViewCell
        if let asset = asset {
            cell.configure((asset.searchResult.shortScreenshots[indexPath.row]))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}
