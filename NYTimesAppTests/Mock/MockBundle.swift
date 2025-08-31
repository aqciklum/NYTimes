//
//  MockBundle.swift
//  NYTimesApp
//
//  Created by Abdul Qadar on 30/8/2025.
//

import Foundation

// Extension for Bundle to mock the API key
extension Bundle {
    private static var mockApiKey: String?
    
    static func setMockApiKey(_ apiKey: String?) {
        mockApiKey = apiKey
    }
    
    // This method is responsible for swizzling the method at runtime
    static func swizzleBundleMethod() {
        let originalSelector = #selector(Bundle.object(forInfoDictionaryKey:))
        let swizzledSelector = #selector(Bundle.mock_object(forInfoDictionaryKey:))

        // Get the original method and swizzled method implementations
        let originalMethod = class_getInstanceMethod(Bundle.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(Bundle.self, swizzledSelector)

        // Swap the method implementations
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    // The mock version of object(forInfoDictionaryKey:) that will return the mocked API key
    @objc private func mock_object(forInfoDictionaryKey key: String) -> Any? {
        if key == "Api_key" {
            return Bundle.mockApiKey
        }
        // Call the original implementation (which is now swapped with this method)
        return self.mock_object(forInfoDictionaryKey: key)
    }
}
