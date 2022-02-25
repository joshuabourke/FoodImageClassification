//
//  CreateAccountView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 18/2/22.
//

import SwiftUI

struct CreateAccountView: View {
    //MARK: - PROPERTIES
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    @State private var emailCreateAccount: String = ""
    @State private var passwordCreateAccount: String = ""
    @State private var reEnterPassWordCreateAccount: String = ""
    
    @Binding var isShowingCreateAccount: Bool
    @Binding var isShowingLogin: Bool
    
    private var isDisabled: Bool {
        emailCreateAccount.isEmpty
    }
    
    //MARK: - BODY
    var body: some View {
        ZStack {
            BlankView(backgroundColor: isDarkMode ? Color.gray : Color.black, backgroundOpacity: isDarkMode ? 0.95 : 0.90)
                .onTapGesture {
                    isShowingCreateAccount = false
                }
            VStack {
                Spacer()
                VStack(alignment: .center, spacing: 16){
                    //MARK: - HERO IMAGE
                    ZStack(alignment: .top) {
                        HStack(alignment: .top) {
                            Text("Cancel")
                                .padding()
                                .foregroundColor(Color.primary)
                                .onTapGesture {
                                    print("Return to main view")
                                    isShowingCreateAccount = false
                                    isShowingLogin = false
                                }
                            Spacer()


                            Text("Login")
                                .padding()
                                .foregroundColor(Color.primary)
                                .onTapGesture {
                                    isShowingLogin = true
                                    isShowingCreateAccount = false
                                }
                        }//: HSTACK
                        Image("LogoNoBackground")
                            .resizable()
                            .scaledToFit()
                        .frame(width: 100, height: 100)
                    }//: ZSTACK

                    //MARK: - TITLE
                    Text("Nutrify")
                        .foregroundColor(Color.primary)
                        .font(.system(.title3).bold())
                    
                    //MARK: - EMAIL
                    HStack(spacing: 0) {
                        Image(systemName: "envelope")
                            .padding(.horizontal)

                            .font(.title3)
                            .foregroundColor(Color.accentColor)
                        TextField("Email", text: $emailCreateAccount)
                            .foregroundColor(Color.primary)
                            .font(.system(.title3).bold())
                            .padding(.vertical)
                            .cornerRadius(12)
                    }//: EMAIL
                    .background(RoundedRectangle(cornerRadius: 12).fill(isDarkMode ? Color(UIColor.secondarySystemBackground) :  Color(UIColor.tertiarySystemBackground)))
                    .padding(.horizontal)
                    
                    //MARK: - PASSWORD
                    HStack {
                        Image(systemName: "lock")
                            .padding(.horizontal)

                            .font(.title3)
                            .foregroundColor(Color.accentColor)
                        TextField("Password", text: $passwordCreateAccount)
                            .foregroundColor(Color.primary)
                            .font(.system(.title3).bold())
                            .padding(.vertical)
                            .cornerRadius(12)
                    }//: PASSWORD
                    .background(RoundedRectangle(cornerRadius: 12).fill(isDarkMode ? Color(UIColor.secondarySystemBackground) :  Color(UIColor.tertiarySystemBackground)))
                    .padding(.horizontal)
                    
                    //MARK: - RE-ENTER PASSWORD
                    HStack {
                        Image(systemName: "lock")
                            .padding(.horizontal)

                            .font(.title3)
                            .foregroundColor(Color.accentColor)
                        TextField("Re-Enter Password", text: $passwordCreateAccount)
                            .foregroundColor(Color.primary)
                            .font(.system(.title3).bold())
                            .padding(.vertical)
                            .cornerRadius(12)
                    }//: PASSWORD
                    .background(RoundedRectangle(cornerRadius: 12).fill(isDarkMode ? Color(UIColor.secondarySystemBackground) :  Color(UIColor.tertiarySystemBackground)))
                    .padding(.horizontal)
                    
                    //MARK: - LOGIN BUTTON
                    Button(action:   {
                        print("Login")
                        isShowingCreateAccount = false
                        isShowingLogin = true
                    } ,label: {
                        Spacer()
                        Text("Create Account")
                            .font(.system(.title3).bold())
                        Spacer()
                    })
                    .padding()
                    .foregroundColor(isDisabled ? Color.gray : Color.primary)
                    .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 4)
                    ).foregroundColor(isDisabled ? Color.gray : Color.accentColor)
                        .background(isDarkMode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground)).cornerRadius(12)

                }
                

                .padding(.horizontal)
                .padding(.vertical, 20)
                .background(isDarkMode ? Color.white : Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 24)
                .frame(maxWidth: 640)
                Spacer()
            }//: VSTACK
            .padding()
        }//: ZSTACK
    }
}

    //MARK: - PREVIEW
struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView(isShowingCreateAccount: .constant(true), isShowingLogin: .constant(false))
    }
}
