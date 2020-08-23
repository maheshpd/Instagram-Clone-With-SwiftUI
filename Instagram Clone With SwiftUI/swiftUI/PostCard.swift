//
//  PostCard.swift
//  Instagram Clone With SwiftUI
//
//  Created by Mahesh Prasad on 23/08/20.
//  Copyright © 2020 CreatesApp. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestore

struct postCard: View {
    
    var user = ""
    var image = ""
    var id = ""
    var likes = ""
    var comments = ""
    
    
    var body: some View {
        VStack(alignment: .leading, content:  {
            HStack {
                AnimatedImage(url: URL(string: image)).resizable().foregroundColor(Color("darkAndWhite"))
                    .frame(width: 30, height: 30).clipShape(Circle())
                Text(user)
                Spacer()
                Button(action: {
                    
                }) {
                    Image("menu").resizable()
                    .frame(width: 15, height: 15)
                }.foregroundColor(Color("darkAndWhite"))
            }
            
            AnimatedImage(url: URL(string: image)).resizable().frame(height: 350).edgesIgnoringSafeArea(.all)
            HStack {
                
                Button(action: {
                    
                }) {
                    Image("comment").resizable()
                    .frame(width: 26, height: 26)
                }.foregroundColor(Color("darkAndWhite"))
                
                Button(action: {
                    //Update likes
                    let like = Int.init(self.likes)!
                    let db = Firestore.firestore()
                    db.collection("posts").document(self.id).updateData(["likes":"\(like + 1)"]) { (err) in
                        
                        if err != nil {
                            print((err))
                            return
                        }
                        print("updated....")
                    }
                }) {
                    Image("heart").resizable()
                    .frame(width: 26, height: 26)
                }.foregroundColor(Color("darkAndWhite"))
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    Image("saved").resizable()
                    .frame(width: 26, height: 26)
                }.foregroundColor(Color("darkAndWhite"))
                
            }.padding(.top, 8)
            
            Text("\(likes) Likes").padding(.top, 8)
            Text("View all \(comments) Comments")
        }).padding(8)
    }
}
