struct PasswordRules {
    static func validate(_ password: String) -> [String] {
        var errors: [String] = []
        
        if password.count < 8 {
            errors.append("Минимум 8 символов")
        }
        
        if password.range(of: "[A-Z]", options: .regularExpression) == nil {
            errors.append("Хотя бы одна заглавная буква")
        }
        
        if password.range(of: "[0-9]", options: .regularExpression) == nil {
            errors.append("Хотя бы одна цифра")
        }
        
        if password.range(of: "[^A-Za-z0-9]", options: .regularExpression) == nil {
            errors.append("Хотя бы один спецсимвол")
        }
        
        return errors
    }
}
