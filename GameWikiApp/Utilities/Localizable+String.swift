//
//  Localizable+String.swift
//  GameWikiApp
//
//  Created by Celil Aydın on 18.02.2023.
//

import Foundation

enum LocalizableString: String {
    case HomeScreenTitle
    case DetailScreenTitle
    case FavoriteScreenTitle
    case SearchScreenTitle
    case DeletedAlertMessage
    case EnterGame
    case SearchGame
    case OnboardingSearchDesc
    case OnboardingFavoDesc
    case OnboardingDetailDesc
    case FavoriteGame
    case SwipeRight
    case AddFavorite
    case AddedFavorite
    case SearchPlaceholder
    
    
    case Success
    case Error
    case DataNotFound
    case Started
    case Next
    
    var localized: String {
        NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
    }
}
