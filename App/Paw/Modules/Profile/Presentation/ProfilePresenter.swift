//
//  ProfilePresenter.swift
//  Paw
//
//  Created by Gordon Smith on 03/09/2022.
//

import Foundation

public enum ProfileComponent: Equatable {
    case image(imageURL: URL)
    case body(viewModel: PetDetailBodyViewModel)
    case tags(viewModel: [String])
    case bookingAction(viewModel: String)
}

public enum ProfilePresenter {
    
    public static var bookingText: String { "Get acquainted today..." }
    
    public static func map(_ profile: Profile, currentDate: @escaping () -> Date = Date.init, calendar: Calendar = .current, locale: Locale = .current) -> [ProfileComponent] {
        
        let dateFormatter = LocalizedRelativeDateTimeFormatter(currentDate: currentDate, calendar: calendar, locale: locale)
        
        var components: [ProfileComponent] = []
        
        components.append(
            .image(imageURL: profile.imageURL)
        )
        
        if !profile.tags.isEmpty {
            components.append(.tags(viewModel: profile.tags))
        }
        
        components.append(
            .body(viewModel: PetDetailBodyViewModel(
                name: profile.name,
                about: profile.about,
                updated: dateFormatter.string(for: profile.lastUpdatedDate))
            )
        )
        
        if profile.isAvailable {
            components.append(
                .bookingAction(viewModel: bookingText)
            )
        }
    
        return components
    }
}
