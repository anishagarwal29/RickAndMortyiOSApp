//
//  APICacheManager.swift
//  RickAndMorty
//
//  Created by Anish Agarwal on 7/11/24.
//

import Foundation

/// Manages in memory session scoped API cachess
final class APICacheManager {
    // Dictionary that stores an NSCache for each endpoint,
    // where each cache maps a URL string to the cached response data
    private var cacheDictionary: [
        RMEndpoint: NSCache<NSString, NSData>
    ] = [:]
    
    init() {
        setUpCache()
    }
    
    // MARK: - Public
    
    /// Retrieves cached data for a given endpoint and url, if it exists
    /// - Parameters:
    ///   - endpoint: The specific `RMEndpoint` for which the data was cached
    ///   - url: the URL for the specufuc request (optional)
    /// - Returns: Cached data if available, otherwise nil
    public func cachedResponse(for endpoint: RMEndpoint, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return nil
        }
        // Generates a cache key using the URL's absolute string
        let key = url.absoluteString as NSString
        // Returns the cached data if it exists, otherwise nil
        return targetCache.object(forKey: key) as? Data
        
    }
    
    // Caches the provided data for a specific endpoint and URL.
    /// - Parameters:
    ///   - endpoint: The `RMEndpoint` to which the data is related.
    ///   - url: The URL of the request (optional); used as the key to store the cached data.
    ///   - data: The data to be cached, typically the API response.
    ///
    /// This method stores the given data in the cache for a specified endpoint and URL.
    /// If the endpoint's cache already contains data for this URL, it will be overwritten.
    public func setCache(for endpoint: RMEndpoint, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return
        }
        // Converts URL to a unique string key and stores the data in the cache
        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
        
    }
    
    // MARK: - Private
    
    private func setUpCache() {
        // Iterates over each endpoint, creating a distinct cache for each
        RMEndpoint.allCases.forEach { endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        }
    }
    
}
