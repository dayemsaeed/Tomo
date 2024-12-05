struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var toggleSecure: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
            
            ZStack(alignment: .trailing) {
                Group {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 16))
                .padding(.trailing, toggleSecure != nil ? 32 : 0)
                .foregroundColor(Color(uiColor: .label)) // Adapts to dark mode
                
                if let toggleSecure = toggleSecure {
                    Button(action: toggleSecure) {
                        Image(systemName: isSecure ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Divider()
                .background(Color.gray.opacity(0.5))
        }
        .padding(.vertical, 8)
    }
} 