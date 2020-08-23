//
//  ContentView.swift
//  Instagram Clone With SwiftUI
//
//  Created by Mahesh Prasad on 23/08/20.
//  Copyright © 2020 CreatesApp. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import SDWebImageSwiftUI


struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                
                Home().navigationBarTitle("Instagram")
                    .navigationBarItems(leading: Button(action: {
                        
                    }, label: {
                        Image("cam").resizable().frame(width: 30, height: 30)
                    })
                        .foregroundColor(Color("darkAndWhite"))
                        , trailing:
                        
                        HStack {
                            Button(action: {
                                
                            }) {
                               Image("IGTV").resizable().frame(width: 30, height: 30)
                            }.foregroundColor(Color("darkAndWhite"))
                            
                            Button(action: {
                                
                            }) {
                               Image("send").resizable().frame(width: 30, height: 30)
                            }.foregroundColor(Color("darkAndWhite"))
                            
                    })
            }.tabItem {
                Image("home")
            }
            
            Text("Find").tabItem {
                Image("find")
            }
            
            Text("Upload").tabItem {
                Image("plus")
            }
            
            Text("Likes").tabItem {
                Image("heart")
            }
            
            Text("Profile").tabItem {
                Image("people")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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

struct StatusCard: View {
    
    var imName = ""
    var user = ""
    @Binding var show : Bool
    @Binding var user1 : String
    @Binding var url : String
    
    
    var body: some View {
        
        VStack{
            AnimatedImage(url: URL(string: imName)).resizable()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
            
                .onTapGesture {
                    self.user1 = self.user
                    self.url = self.imName
                    self.show.toggle()
            }

            Text(user).fontWeight(.light)
            
        }

    }
}

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

class observer: ObservableObject {
    @Published var status = [datatype]()
    
    init() {
        let db = Firestore.firestore()
        db.collection("status").addSnapshotListener { (snap, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            
            for i in snap!.documentChanges{
                if i.type == .added {
                    let id = i.document.documentID
                    let name = i.document.get("name") as! String
                    let image = i.document.get("image") as! String
                    
                    self.status.append(datatype(id: id, name: name, image: image))
                }
                
                if i.type == .removed {
                    let id = i.document.documentID
                    
                    for j in 0..<self.status.count {
                        
                        if self.status[j].id == id {
                            self.status.remove(at: j)
                            return
                        }
                    }
                    
                }
                
            }
        }
    }
}

class Postsobserver: ObservableObject {
    @Published var posts = [datatype1]()
    
    init() {
        let db = Firestore.firestore()
        db.collection("posts").addSnapshotListener { (snap, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            
            for i in snap!.documentChanges{
                if i.type == .added {
                    let id = i.document.documentID
                    let name = i.document.get("name") as! String
                    
                    let image = i.document.get("image") as! String
                    
                    let comment = i.document.get("comments") as! String

                    let likes = i.document.get("likes") as! String
                    
                    self.posts.append(datatype1(id: id, name: name, image: image, comments: comment, likes: likes))
                }
                
                if i.type == .removed {
                    let id = i.document.documentID
                    
                    for j in 0..<self.posts.count {
                        
                        if self.posts[j].id == id {
                            self.posts.remove(at: j)
                            return
                        }
                    }
                    
                }
                
                if i.type == .modified {
                    let id = i.document.documentID
                    let like = i.document.get("likes") as! String
                    
                    for j in 0..<self.posts.count {
                        
                        if self.posts[j].id == id {
                            self.posts[j].likes = like
                            return
                        }
                    }
                    
                }
                
                
            }
        }
    }
}

struct datatype1: Identifiable {
    
    var id: String
    var name : String
    var image : String
    var comments : String
    var likes : String
}


struct datatype: Identifiable {
    
    var id: String
    var name : String
    var image : String
}

struct statusView : View {
    
    var url = ""
    var name = ""
    var body: some View {
        
        
        ZStack {
            AnimatedImage(url: URL(string: url)).resizable().edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text(name).font(.headline).fontWeight(.heavy).padding()
                    Spacer()
                }
                
                Spacer()
            }
        }
    }
    
}

//oops i forget
