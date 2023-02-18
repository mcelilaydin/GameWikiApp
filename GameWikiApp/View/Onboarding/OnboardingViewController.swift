//
//  ViewController.swift
//  GameApp
//
//  Created by Celil Aydın on 4.02.2023.
//

import UIKit
import Loaf

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides: [OnboardingSlide] = []
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextButton.layer.opacity = 1
                nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
                nextButton.setTitle(LocalizableString.Started.localized, for: .normal)
            }else {
                nextButton.layer.opacity = 0.5
                nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
                nextButton.setTitle(LocalizableString.Next.localized, for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        setSlides()
        setView()
        // Do any additional setup after loading the view.
    }
    
    private func setView() {
        nextButton.layer.opacity = 0.5
    }
    
    private func setSlides() {
        slides = [
            OnboardingSlide(title: LocalizableString.SearchGame.localized, description: LocalizableString.OnboardingSearchDesc.localized, image:UIImage(named: "onboard1")!),
            OnboardingSlide(title: LocalizableString.FavoriteGame.localized, description: LocalizableString.OnboardingFavoDesc.localized, image:UIImage(named: "onboard2")!),
            OnboardingSlide(title: LocalizableString.DetailScreenTitle.localized, description: LocalizableString.OnboardingDetailDesc.localized, image:UIImage(named: "onboard3")!)
        ]
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        if currentPage == slides.count - 1 {
            UserDefaults.standard.set(true, forKey: "openApp")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! UITabBarController
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .flipHorizontal
            self.present(vc, animated: true)
        }else {
            Loaf(LocalizableString.SwipeRight.localized, state: .error, sender: self).show()
        }
    }
}

extension OnboardingViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.configure(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
