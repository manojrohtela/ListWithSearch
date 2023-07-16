//
//  ContentView.swift
//  ViewBuilderWithListModel
//
//  Created by Manoj Kumar on 15/07/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var classViewModel = ViewModel()
    var body: some View {
        VStack{
            List{
                ForEach($classViewModel.classes.classDetail, id: \.id){ classDetail in
                    CustomCellForParent(classDetailModel: classDetail)
                }
            }
            
        }
        .background(Color.gray)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CustomCellForParent: View{
    
    @Binding var classDetailModel:ClassDetailModel
    @State private var isShowOption: Bool = false
    
    @State private var searchText: String = ""
    
    @State var filteredModel: ClassDetailModel = ClassDetailModel(className: "", stuDetails: [])
    

    
    var body: some View {
        VStack{
            HStack{
                Button {
                    isShowOption.toggle()
                } label: {
                    Text(classDetailModel.className)
                        .padding(0)
                        .frame(width: 350, height: 30, alignment: .leading)
                        .padding(0)
                }
            }
            .padding(0)
            .frame(width: 350, height: 30, alignment: .center)
            
            VStack {
                
                TextField("Search", text: $searchText)
                    .onChange(of: searchText, perform: { newValue in
                        if !checkStuIsSelected().isEmpty {
                            for item in filteredModel.stuDetails{
                                if let index = classDetailModel.stuDetails.firstIndex(where: { ($0.name.lowercased() == item.name.lowercased()) }) {
                                    classDetailModel.stuDetails[index].isPass = item.isPass
                                }
                            }
                        }
                        if newValue.isEmpty{
                            filteredModel.stuDetails = classDetailModel.stuDetails
                                
                            }else{
                                filteredModel.stuDetails = classDetailModel.stuDetails.filter{$0.name.localizedCaseInsensitiveContains(searchText)}
                            }
                    })
                    .padding(20.0)
                List{
                        ForEach($filteredModel.stuDetails, id: \.id) { row in
                            CustomCell(studDetail: row)
                        }
                }
               
            }
            .opacity(isShowOption ? 1 : 0)
            .frame(width: 398, height: isShowOption ? 360 : 0)
            
            HStack{
                List{
                    let data = checkStuIsSelected()
                        ForEach(data, id: \.id) { row in
                            CustomCellText(studDetail: row)
                        }
                }
            }
            .frame(width: 398, height: (!checkStuIsSelected().isEmpty && !isShowOption) ? CGFloat((checkStuIsSelected().count) * 60) : 0)
        }
        .padding(0)
        .frame(alignment: .leading)
        .onAppear{
            filteredModel = classDetailModel
            print("sdfsddfdsf")
        }
    }
    
    func checkStuIsSelected()->Array<Binding<StuModel>>{
        let arr = $filteredModel.stuDetails.filter { stu in
            return stu.isPass.wrappedValue
        }
        
        return arr
    }
    
    
    
}



struct CustomCell: View{
    
    @Binding var studDetail:StuModel
    var body: some View {
        VStack{
            Button {
                studDetail.isPass.toggle()
            } label: {
                Text(studDetail.name)
                    .padding(0)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .foregroundColor(studDetail.isPass ? .black : .white)
            .background(Color.red)
        }
        
    }
}

struct CustomCellText: View{
    
    @Binding var studDetail:StuModel
    var body: some View {
        Text(studDetail.name)
            .background(Color.yellow)
    }
}


struct ClassModel{
    var classDetail: [ClassDetailModel]
}

struct ClassDetailModel {
    
    var id = UUID().uuidString
    var className: String
    var stuDetails: [StuModel]
}


struct StuModel: Identifiable{
    var id = UUID().uuidString
    var name: String
    var isPass: Bool
}



class ViewModel: ObservableObject{
    @Published var classes: ClassModel
    
    init() {
        let stuDetail = StuModel(name: "Manoj", isPass: false)
        let stuDetail2 = StuModel(name: "shivam", isPass: false)
        let stuDetail3 = StuModel(name: "Kapil", isPass: false)
        let stuDetail4 = StuModel(name: "Sachin", isPass: false)
        let stuDetail5 = StuModel(name: "Arvind", isPass: false)
        let stuDetail6 = StuModel(name: "Neeraj", isPass: false)
        
        let classDetail1 = ClassDetailModel(className: "First", stuDetails: [stuDetail,stuDetail2,stuDetail3,stuDetail4,stuDetail5,stuDetail6])
        let classDetail2 = ClassDetailModel(className: "Second", stuDetails: [stuDetail,stuDetail2,stuDetail3,stuDetail4,stuDetail5,stuDetail6])
        let classDetail3 = ClassDetailModel(className: "Third", stuDetails: [stuDetail,stuDetail2,stuDetail3,stuDetail4,stuDetail5,stuDetail6])
        let classDetail4 = ClassDetailModel(className: "Fourth", stuDetails: [stuDetail,stuDetail2,stuDetail3,stuDetail4,stuDetail5,stuDetail6])
        let classDetail5 = ClassDetailModel(className: "Fifth", stuDetails: [stuDetail,stuDetail2,stuDetail3,stuDetail4,stuDetail5,stuDetail6])
        let classDetail6 = ClassDetailModel(className: "Sixth", stuDetails: [stuDetail,stuDetail2,stuDetail3,stuDetail4,stuDetail5,stuDetail6])
        
        self.classes = ClassModel(classDetail: [classDetail1, classDetail2, classDetail3, classDetail4, classDetail5, classDetail6])
    }
}
