//
//  CategoriesVM.swift
//  GoHelpFund-Platform
//
//  Created by Vlad Batrinu on 8/3/18.
//  Copyright © 2018 cacheOverflow. All rights reserved.
//

import Foundation

public class CategoriesVM {
    let campaignApiService = CampaignService()
    private var categories = [Category]()
    
    func getCategories(success: @escaping () -> (), failure: @escaping () -> ()) {
        campaignApiService.getCategories(success: {[weak self] (categories) in
            self?.categories = categories
            success()
        }) {
            failure()
        }
    }
    
    var categoriesCount: Int {
        return categories.count
    }
 
    func cellVM(at index: Int) -> CategoryCellVM {
        return CategoryCellVM(category: category(at: index))
    }
    
    func category(at index: Int) -> Category {
        return categories[index]
    }
}

public class CategoryCellVM {
    var category: Category
    
    init(category: Category) {
        self.category = category
    }
    
    var imageUrl: URL? {
        return URL(string: category.imageURL)
    }
    
    var title: String {
        return category.name
    }
}
