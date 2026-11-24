import SwiftUI

struct FriendItem: Identifiable {
    let id = UUID()
    let initials: String
    let name: String
    let group: String
    let bgColor: Color
    let fgColor: Color
}

struct FriendsView: View {
    @State private var searchText = ""
    @State private var pendingInvite: FriendItem? = FriendItem(
        initials: "MK",
        name: "Michał Kamiński",
        group: "Z grupy Aktywnie w Warszawie",
        bgColor: CatchMeTheme.softGreen,
        fgColor: CatchMeTheme.primaryGreen
    )
    
    @State private var friends: [FriendItem] = [
        FriendItem(initials: "KK", name: "Kasia Kowalska", group: "Kawa i rozmowy", bgColor: CatchMeTheme.iconBeigeBg, fgColor: CatchMeTheme.iconBeigeFg),
        FriendItem(initials: "PW", name: "Piotr Wiśniewski", group: "Aktywnie w Warszawie", bgColor: CatchMeTheme.softGreen, fgColor: CatchMeTheme.primaryGreen),
        FriendItem(initials: "OZ", name: "Ola Zielińska", group: "Planszówkowa ekipa", bgColor: CatchMeTheme.iconPurpleBg, fgColor: CatchMeTheme.iconPurpleFg),
        FriendItem(initials: "ML", name: "Marta Lewandowska", group: "Kawa i rozmowy", bgColor: CatchMeTheme.iconBeigeBg, fgColor: CatchMeTheme.iconBeigeFg)
    ]
    
    var filteredFriends: [FriendItem] {
        if searchText.isEmpty { return friends }
        return friends.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.group.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                CatchMeTopHeader(initials: "AN")
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Znajomi")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(CatchMeTheme.textPrimary)
                        
                        Text("Najlepsze plany zaczynają się od ludzi.")
                            .font(.system(size: 14))
                            .foregroundColor(CatchMeTheme.textSecondary)
                    }
                    
                    Spacer()
                    
                    Button {
                        // Akcja dodawania znajomego
                    } label: {
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(CatchMeTheme.primaryGreen)
                            .frame(width: 38, height: 38)
                            .background(CatchMeTheme.softGreen)
                            .cornerRadius(10)
                    }
                }
                
                CatchMeSearchBar(placeholder: "Szukaj znajomego", text: $searchText)
                
                // Sekcja zaproszeń
                if let invite = pendingInvite {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Zaproszenia")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(CatchMeTheme.textPrimary)
                            
                            Spacer()
                            
                            Text("1 nowe")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(CatchMeTheme.primaryGreen)
                        }
                        
                        VStack(spacing: 14) {
                            HStack(spacing: 12) {
                                Text(invite.initials)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(invite.fgColor)
                                    .frame(width: 42, height: 42)
                                    .background(invite.bgColor)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(invite.name)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(CatchMeTheme.textPrimary)
                                    
                                    Text(invite.group)
                                        .font(.system(size: 12))
                                        .foregroundColor(CatchMeTheme.textSecondary)
                                }
                                
                                Spacer()
                            }
                            
                            HStack(spacing: 10) {
                                Button {
                                    withAnimation {
                                        friends.insert(
                                            FriendItem(initials: invite.initials, name: invite.name, group: "Aktywnie w Warszawie", bgColor: invite.bgColor, fgColor: invite.fgColor),
                                            at: 0
                                        )
                                        pendingInvite = nil
                                    }
                                } label: {
                                    Text("Akceptuj")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 40)
                                        .background(CatchMeTheme.primaryGreen)
                                        .cornerRadius(10)
                                }
                                
                                Button {
                                    withAnimation { pendingInvite = nil }
                                } label: {
                                    Text("Odrzuć")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(CatchMeTheme.textSecondary)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 40)
                                        .background(CatchMeTheme.surfaceGray)
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding(14)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(CatchMeTheme.softGreenBorder, lineWidth: 1)
                        )
                        .cornerRadius(16)
                    }
                }
                
                // Sekcja Twoi znajomi
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Twoi znajomi")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(CatchMeTheme.textPrimary)
                        
                        Spacer()
                        
                        Text("\(filteredFriends.count) osoby")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(CatchMeTheme.primaryGreen)
                    }
                    
                    VStack(spacing: 10) {
                        ForEach(filteredFriends) { friend in
                            HStack(spacing: 12) {
                                Text(friend.initials)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(friend.fgColor)
                                    .frame(width: 40, height: 40)
                                    .background(friend.bgColor)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(friend.name)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(CatchMeTheme.textPrimary)
                                    
                                    Text(friend.group)
                                        .font(.system(size: 12))
                                        .foregroundColor(CatchMeTheme.textSecondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 13))
                                    .foregroundColor(CatchMeTheme.textSecondary)
                            }
                            .padding(14)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(CatchMeTheme.borderGray, lineWidth: 1)
                            )
                            .cornerRadius(16)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(CatchMeTheme.background)
    }
}
