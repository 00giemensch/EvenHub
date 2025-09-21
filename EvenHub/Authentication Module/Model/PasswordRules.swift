struct PasswordRules {
    static func validate(_ password: String) -> [String] {
        var errors: [String] = []
        
        if password.count < 8 {
            errors.append("Minimum password length is 8")
        }
        
        // Проверка на наличие хотя бы одного символа в верхнем регистре (в любом языке)
        if password.range(of: "\\p{Lu}", options: .regularExpression) == nil {
            errors.append("Require uppercase character")
        }
        
        // Проверка на наличие хотя бы одной цифры (любые юникодные цифры)
        if password.range(of: "\\p{Nd}", options: .regularExpression) == nil {
            errors.append("Require numeric character")
        }
        
        // Проверка на наличие хотя бы одного спецсимвола (не буквы и не цифры)
        if password.range(of: "[^\\p{L}\\p{Nd}]", options: .regularExpression) == nil {
            errors.append("Require special character")
        }
        
        return errors
    }
}
