//
//  FeedDataSource.swift
//  Photo Feed
//
//  Created by Artem Yakovlev on 24.03.2022.
//

import UIKit
import Photos

enum FeedState {
    case loaded
    case empty
    case accessDenied
}

class FeedDelegateDataSource: NSObject {
    
    private var allPhotos: PHFetchResult<PHAsset>?
    
    public func loadPhotos(complition: ((FeedState) -> Void)? = nil) {
        PhotoLibraryManager().loadPhotos { [weak self] photos in
            self?.allPhotos = photos
            
            let state: FeedState
            
            if self?.allPhotos == nil {
                state = .accessDenied
            } else if self?.allPhotos?.count == 0 {
                state = .empty
            } else {
                state = .loaded
            }
            
            complition?(state)
        }
    }
    
    private func getAsset(at indexPath: IndexPath) -> PHAsset? {
        guard let photos = allPhotos else { return nil }
        return allPhotos?.object(at: photos.count - indexPath.row - 1)
    }
    
}

// MARK: - UITableViewDataSource

extension FeedDelegateDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allPhotos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let asset = getAsset(at: indexPath),
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell") as? FeedTableViewCell
        else {
            return UITableViewCell()
        }
        
        PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: nil) { image, _ in

            guard
                let image = image,
                let cell = tableView.cellForRow(at: indexPath) as? FeedTableViewCell
            else {
                return
            }
            
            cell.setImage(image)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FeedDelegateDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photoWidth = getAsset(at: indexPath)?.pixelWidth ?? 0
        let photoHeight = getAsset(at: indexPath)?.pixelHeight ?? 0
        
        let imageWidth = CGFloat(photoWidth) / UIScreen.main.scale
        var imageHeight = CGFloat(photoHeight) / UIScreen.main.scale
        
        imageHeight *= tableView.bounds.width / imageWidth
        
        return round(imageHeight)
    }
}
