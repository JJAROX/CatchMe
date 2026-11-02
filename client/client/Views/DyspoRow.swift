import SwiftUI

struct DyspoRow: View {
    let dyspo: Dyspo
    
    var body: some View {
        HStack {
            Text(dyspo.intentIcon)
                .font(.largeTitle)
                .padding(.trailing, 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(dyspo.userName)
                    .font(.headline)
                Text(dyspo.locationZone)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("Do:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(dyspo.endTime, style: .time)
                    .font(.subheadline)
                    .bold()
            }
        }
        .padding(.vertical, 4)
    }
}
