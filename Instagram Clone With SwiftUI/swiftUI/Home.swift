//
//  Home.swift
//  Instagram Clone With SwiftUI
//
//  Created by Mahesh Prasad on 23/08/20.
//  Copyright © 2020 CreatesApp. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore

struct Home: View {
    
    @ObservedObject var observed = observer()
    @ObservedObject var postsobserver = Postsobserver()
    @State var show = false
    @State var user = ""
    @State var url = ""
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false){
            VStack{
                ScrollView(.horizontal,showsIndicators: false) {
                    HStack {
                        
                        ForEach(observed.status) { i in
                            StatusCard(imName: i.image, user: i.name, show: self.$show, user1: self.$user, url: self.$url).padding(.leading, 10)
                        }
                    }.animation(.spring())
                }
                
                                
                if postsobserver.posts.isEmpty {
                    Text("No Posts").fontWeight(.heavy)
                } else {
                    ForEach(postsobserver.posts) {i in
                        postCard(user: i.name, image: i.image, id: i.id, likes: i.likes, comments: i.comments)
                    }

                }
                
                
            }
        }.sheet(isPresented: $show) {
            statusView(url: self.url, name: self.user)
        }
        
    }
}
