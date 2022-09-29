//
//  HomeDataModel.swift
//  
//
//  Created by Yoshiki Hemmi on 2022/09/30.
//

import Combine
import Domain

public struct HomeDataModel {
    public var items: [RepositoryEntity]
    public var query: QueryDto = QueryDto(keyword: "swift")
    public var totalCount: Int = -1
    public var hasNextPage: Bool {
        items.count < totalCount
    }
    
    public init(items: [RepositoryEntity] = []) {
        self.items = items
    }
}

public extension HomeDataModel {
    var isEmpty: Bool {
        items.isEmpty
    }
    
    func findIndex(item: RepositoryEntity) -> Int {
        items.firstIndex(where: { $0.id == item.id }) ?? -1
    }
    
    mutating func refresh() {
        self.items.removeAll()
        self.totalCount = -1
    }
    
    mutating func update(data: SearchResponseEntity) {
        data.items.forEach {
            if findIndex(item: $0) > 0 { return }
            self.items.append($0)
        }
        self.totalCount = data.totalCount
    }
}
