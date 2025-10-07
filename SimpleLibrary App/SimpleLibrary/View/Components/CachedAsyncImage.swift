//
//  CachedAsyncImage.swift
//  SimpleLibrary
//
//  Created by Manuel Alejandro Santana Ramirez on 4/10/25.
//

import SwiftUI

struct CachedAsyncImage: View {
    
    var url:String
    var width:CGFloat
    var height:CGFloat
    
    
    var body: some View {
        
        AsyncImage(url: URL(string: url)){
            phase in
            
            
            switch phase{
            case .success(let image):
                image
                    .resizable()
                    .frame(width: width, height: height)
            case .failure:
                Image(systemName: "photo")
                            .frame(width: width, height: height)
            case .empty:
                ProgressView()
                    .frame(width:width, height: height)
            @unknown default:
                EmptyView()
            }
            
            
        }
    }
}

#Preview {
    CachedAsyncImage(url:"https://m.media-amazon.com/images/I/713jIoMO3UL.jpg", width:300, height:500)
}
