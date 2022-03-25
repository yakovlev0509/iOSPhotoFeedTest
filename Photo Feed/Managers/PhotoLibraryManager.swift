//
//  PhotoLibraryManager.swift
//  Photo Feed
//
//  Created by Artem Yakovlev on 24.03.2022.
//

import Foundation
import Photos

class PhotoLibraryManager {
    
    public func loadPhotos(complition: @escaping (PHFetchResult<PHAsset>?) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        let fetchAssetsClosure: (PHAuthorizationStatus) -> Void = { status in
            switch status {
            case .authorized, .limited:
                let assets = PHAsset.fetchAssets(with: .image, options: nil)
                complition(assets)
            default:
                complition(nil)
            }
        }
        
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                fetchAssetsClosure(status)
            }
        } else {
            fetchAssetsClosure(status)
        }
    }
    
}
