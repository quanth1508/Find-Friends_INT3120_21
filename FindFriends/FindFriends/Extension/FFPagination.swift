//
//  FFPagination.swift
//  FF
//
//  Created by Son Le on 05/05/2022.
//

import Foundation

public struct FFPagination {
    public var isFetching: Bool = false
    public var hasMore: Bool = true
    public var page: Int = 0
    public let pageStart: Int
    public var limit: Int = 20
    
    public init(pageStart: Int = 0) {
        self.pageStart = pageStart
        self.page      = pageStart
    }
    
    public var readyToLoadMore: Bool {
        !isFetching && hasMore
    }
    
    public mutating func reset() {
        isFetching = false
        hasMore = true
        page = pageStart
    }
    
    public func isRefreshing() -> Bool {
        isFetching && (page == pageStart)
    }
}
