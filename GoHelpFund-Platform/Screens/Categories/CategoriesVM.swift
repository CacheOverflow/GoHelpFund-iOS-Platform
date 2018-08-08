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
        let category = categories[index]
        return CategoryCellVM(category: category)
    }
}

public class CategoryCellVM {
    var category: Category
    
    init(category: Category) {
        self.category = category
    }
    
    var imageUrl: URL? {
        return URL(string: category.imageUrl)
    }
    
    var title: String {
        return category.title
    }
}
