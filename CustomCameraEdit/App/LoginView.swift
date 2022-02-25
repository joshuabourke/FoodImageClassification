//
//  LoginView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 17/2/22.
//

import SwiftUI
import AuthenticationServices

struct AppleUser: Codable {
    let userId: String
    let firstName: String
    let lastName: String
    let email: String
    
    init?(credentials: ASAuthorizationAppleIDCredential) {
        guard
            let firstName = credentials.fullName?.givenName,
            let lastName = credentials.fullName?.familyName,
            let email = credentials.email
        else {return nil}
        
        self.userId = credentials.user
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}


struct LoginView: View {
    //MARK: - PROPERTIES
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    @State private var emailTextField: String = ""
    @State private var passwordTextField: String = ""
    
    @Binding var isShowingLogin: Bool
    @Binding var isShowingCreateAccount: Bool
    
    private var isDisabled: Bool {
        emailTextField.isEmpty
    }
    
    
    
    //MARK: - BODY
    var body: some View {
        ZStack {
            BlankView(backgroundColor: isDarkMode ? Color.gray : Color.black, backgroundOpacity: isDarkMode ? 0.95 : 0.90)
                .onTapGesture {
                    isShowingLogin = false
                }
            VStack {
                Spacer()
                VStack(spacing: 16){
                    //MARK: - HERO IMAGE
                    ZStack(alignment: .top) {
                        HStack(alignment: .top) {
                            Text("Cancel")
                                .padding()
                                .foregroundColor(Color.primary)
                                .onTapGesture {
                                    print("Return to main view")
                                    isShowingLogin = false
                                    isShowingCreateAccount = false
                                }
                            Spacer()
                            
                        }//: HSTACK
                        Image("LogoNoBackground")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100, alignment: .center)
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
                        TextField("Email", text: $emailTextField)
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
                        TextField("Password", text: $passwordTextField)
                            .foregroundColor(Color.primary)
                            .font(.system(.title3).bold())
                            .padding(.vertical)
                            .cornerRadius(12)
                    }//: PASSWORD
                    .background(RoundedRectangle(cornerRadius: 12).fill(isDarkMode ? Color(UIColor.secondarySystemBackground) :  Color(UIColor.tertiarySystemBackground)))
                    .padding(.horizontal)
                    
                    //MARK: - LOGIN BUTTON
                    Button {
                        print("Login")
                    } label: {
                        Spacer()
                        Text("Login")
                            .font(.system(.title3).bold())
                        Spacer()
                    }
                    .padding()
                    .foregroundColor(isDisabled ? Color.gray : Color.primary)
                    .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 4)
                    ).foregroundColor(isDisabled ? Color.gray : Color.accentColor)
                        .background(isDarkMode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground)).cornerRadius(12)
                    
                    //MARK: - ALTERNATE LOG IN
                    
                    
                    
                    //MARK: - LOG IN WITH APPLE
                    SignInWithAppleButton(.signIn, onRequest: configure(_:), onCompletion: handle(_:))
                        .frame(height: 60)
                        .cornerRadius(12)

                    
                    //MARK: - FORGOT PASSWORD
                    HStack {
                        Text("Forgot Password?")
                            .font(.caption)
                        Text("Click here")
                            .font(.caption).underline()
                            .foregroundColor(Color.accentColor)
                    }
                    //MARK: - CREATE ACCOUNT BUTTON
                    Text("Create Account")
                        .font(.title3).underline()
                        .foregroundColor(Color.accentColor)
                        .onTapGesture {
                            print("Create Account Tapped")
                            isShowingLogin = false
                            isShowingCreateAccount = true
                        }
                    
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

//MARK: - APPLE SIGN FUNC'S
// Tutorial's   https://www.youtube.com/watch?v=O2FVDzoAB34&list=WL&index=2&t=335s&ab_channel=KiloLoco
//              https://codeburst.io/sign-in-with-apple-swiftui-4d7bf7c681cd
func configure(_ request: ASAuthorizationAppleIDRequest) {
    request.requestedScopes = [.fullName, .email]
    

}

func handle(_ authResult: Result<ASAuthorization, Error>) {
    switch authResult {
    case.success(let auth):
        print(auth)
        
        switch auth.credential {
            case let appleIdCredentials as
            ASAuthorizationAppleIDCredential :
            if let appleUser = AppleUser(credentials: appleIdCredentials), let appleUserData = try? JSONEncoder().encode(appleUser) {
                UserDefaults.standard.setValue(appleUserData, forKey: appleUser.userId)
                
                print("Saved apple user", appleUser)
            } else {
                print("Missing some fields", appleIdCredentials.email, appleIdCredentials.fullName, appleIdCredentials.user)
                
                guard
                    let appleUserData = UserDefaults.standard.data(forKey: appleIdCredentials.user),
                    let appleUser = try? JSONDecoder().decode(AppleUser.self, from: appleUserData)
                else { return }
                
                print(appleUser)
            }
            
        default:
            print(auth.credential)
        }
        
    case .failure(let error):
        print(error)
    }
    
}

    //MARK: - PREVIEW
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isShowingLogin: .constant(true), isShowingCreateAccount: .constant(false))
//            .background(Color.gray.edgesIgnoringSafeArea(.all))
    }
}
