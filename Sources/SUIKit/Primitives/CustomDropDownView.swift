//
//  CustomDropDownView.swift
//  Open Money
//
//  Created by Roman on 11.07.2023.
//

import SwiftUI

//struct CustomDropDown: View { не используется пока
//    
//    //MARK: - Properties
//    @Binding var selection: String
//    var activeTint: Color
//    var inActiveTint: Color
//    var dynamic: Bool = true
//    
//    private enum Constant {
//        static let rowHeight: CGFloat = 30
//    }
//    
//    var content = ["Day", "Week", "Month", "Year"]
//    
//    @State private var expandView: Bool = false
//    
//    var body: some View {
//        GeometryReader {
//            let size = $0.size
//            VStack(alignment: .leading, spacing: 0) {
//                if !dynamic {
//                    RowView(selection, size)
//                }
//                ForEach(content.filter {dynamic ? true : $0 != selection }, id: \.self) { title in
//                    RowView(title, size)
//                }
//            }
//            .background {
//                Rectangle()
//                    .fill(.red)
//            }
//            .offset(y: dynamic ? (CGFloat(content.firstIndex(of: selection) ?? 0) *  -Constant.rowHeight) : 0)
//        }
//        .frame(height: Constant.rowHeight)
//        .overlay(alignment: .trailing) {
//            Image(systemName: expandView ? "chevron.up" : "chevron.down")
//                .padding(.trailing, 10)
//                .scaleEffect(0.7)
//        }
//        .mask(alignment: .top) {
//            Rectangle()
//                .fill(.red)
//                .frame(height: expandView ? CGFloat(content.count) * Constant.rowHeight : Constant.rowHeight)
//                .offset(y: dynamic && expandView ? (CGFloat(content.firstIndex(of: selection) ?? 0) * -Constant.rowHeight) : 0)
//        }
//    }
//    
//    @ViewBuilder
//    func RowView(_ title: String,_ size: CGSize) -> some View {
//        Text(title)
//            .font(.subheadline)
//            .fontWeight(.semibold)
//            .padding(.horizontal)
//            .frame(width: size.width, height: size.height, alignment: .leading)
//            .background {
//                if selection == title {
//                    Rectangle()
//                        .fill(activeTint)
//                        .cornerRadius(10)
//                        .transition(.identity)
//                }
//            }
//            .contentShape(Rectangle())
//            .onTapGesture {
//                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
//                    if expandView {
//                        
//                        expandView = false
//                        if dynamic {
//                            selection = title
//                        } else {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
//                                selection = title
//                            }
//                        }
//                    } else {
//                        if selection == title {
//                            expandView = true
//                        }
//                    }
//                }
//            }
//    }
//}
//
//struct CustomDropDown_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
