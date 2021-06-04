//
//  ColorsPalette.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 06.05.2021.
//

import UIKit

enum NavigationPalette {
    static let navigationBackground = UIColor.white
    static let navigationTint = UIColor(integralRed: 19, green: 24, blue: 42)
    static let navigationTrackTint = UIColor(integralRed: 241, green: 246, blue: 254)
    static let navigationProgressTint = UIColor(integralRed: 73, green: 132, blue: 241)
    static let tabTint = UIColor(integralRed: 73, green: 132, blue: 241)
    static let tabBarBackground = UIColor.white
}

enum TrophyPalette {
    static let background = UIColor(integralRed: 143, green: 207, blue: 99)
    static let title = UIColor.white
    static let buttonTint = UIColor.white
    static let buttonBackground = UIColor.clear
}

enum StudyPalette {
    static let background = UIColor.white
    static let primaryButton = UIColor(integralRed: 73, green: 132, blue: 241)
    static let secondaryButton = UIColor(integralRed: 241, green: 246, blue: 254)
    static let primaryButtonText = UIColor.white
    static let secondaryButtonText = UIColor(integralRed: 73, green: 132, blue: 241)
    static let title = UIColor(integralRed: 19, green: 24, blue: 42)
    
    enum Brief {
        static let selected = UIColor(integralRed: 73, green: 132, blue: 241)
        static let text = UIColor(integralRed: 19, green: 24, blue: 42)
        static let selectedText =  UIColor.white
        static let weekdayText = UIColor(integralRed: 19, green: 24, blue: 42, alpha: 0.5)
    }
    
    enum Course {
        static let selected = UIColor(integralRed: 73, green: 132, blue: 241)
        static let deselected = UIColor(integralRed: 241, green: 246, blue: 254)
        static let title = UIColor(integralRed: 19, green: 24, blue: 42)
        static let subtitle = UIColor(integralRed: 75, green: 81, blue: 102)
        static let selectedText = UIColor.white
        // Нет компонента
        static let addCourse = UIColor(integralRed: 232, green: 234, blue: 237)
        static let progressText = UIColor(integralRed: 75, green: 81, blue: 102)
    }
    
    enum Mode {
        static let background = UIColor(integralRed: 241, green: 246, blue: 254)
        static let iconBackground = UIColor(integralRed: 73, green: 132, blue: 241)
        static let iconTint = UIColor.white
        static let markBackground = UIColor(integralRed: 254, green: 241, blue: 129)
        static let markText = UIColor(integralRed: 19, green: 24, blue: 42)
        static let title = UIColor(integralRed: 19, green: 24, blue: 42)
    }
}

enum TimedExamPalette {
    static let background = UIColor.white
    static let title = UIColor(integralRed: 75, green: 81, blue: 102)
    static let subtitle = UIColor(integralRed: 19, green: 24, blue: 42)
    static let closeTint = UIColor(integralRed: 19, green: 24, blue: 42)
    static let startButton = UIColor(integralRed: 73, green: 132, blue: 241)
    static let startButtonTint = UIColor.white
}

enum ScorePalette {
    static let background = UIColor(integralRed: 73, green: 132, blue: 241)
    static let containerBackground = UIColor.white
    static let title = UIColor.white
    static let progress = UIColor(integralRed: 75, green: 81, blue: 102)
    static let progressWarning = UIColor(integralRed: 241, green: 104, blue: 91)
}

enum TestPalette {
    static let background = UIColor(integralRed: 241, green: 246, blue: 254)
    static let primaryButton = UIColor(integralRed: 73, green: 132, blue: 241)
    static let secondaryButton = UIColor(integralRed: 73, green: 132, blue: 241)
    static let primaryTint = UIColor.white
    static let secondaryTint = UIColor.white
    static let questionText = UIColor(integralRed: 19, green: 24, blue: 42)
    static let explanationTitle = UIColor(integralRed: 19, green: 24, blue: 42)
    static let explanationText = UIColor(integralRed: 75, green: 81, blue: 102)
    static let bottomGradients = [
        UIColor.clear,
        UIColor(integralRed: 241, green: 246, blue: 254),
    ].map { $0.cgColor }
    
    enum Answer {
        static let text = UIColor(integralRed: 75, green: 81, blue: 102)
        static let selectedText = UIColor.white
        static let selectedBorder = UIColor(integralRed: 73, green: 132, blue: 241)
        static let initialBorder = UIColor.clear
        static let warningBorder = UIColor(integralRed: 157, green: 215, blue: 117)
        static let initialBackground = UIColor.white
        static let incorrectBackground = UIColor(integralRed: 241, green: 104, blue: 91)
        static let correctBackground = UIColor(integralRed: 157, green: 215, blue: 117)
        static let warningBackground = UIColor(integralRed: 157, green: 215, blue: 117, alpha: 0.15)
    }
    
    enum QuestionNumber {
        static let background = UIColor.white
        static let text = UIColor(integralRed: 19, green: 24, blue: 42)
        static let selectedBackground = UIColor(integralRed: 73, green: 132, blue: 241)
        static let selectedText = UIColor.white
    }
}

enum CourseDetailsPalette {
    static let primaryButton = UIColor.white
    static let primaryTint = UIColor(integralRed: 75, green: 81, blue: 102)
    // Не используется
    static let secondaryButton = UIColor(integralRed: 41, green: 55, blue: 137)
    // Не используется
    static let secondaryTint = UIColor(integralRed: 245, green: 245, blue: 245)
    static let correctGradient = UIColor(integralRed: 157, green: 215, blue: 117)
    static let incorrectGradient = UIColor(integralRed: 241, green: 104, blue: 91)
    static let emptyGradient = UIColor(integralRed: 241, green: 246, blue: 254)
    static let title = UIColor(integralRed: 19, green: 24, blue: 42)
    static let subtitle = UIColor(integralRed: 75, green: 81, blue: 102)
    static let background = UIColor(integralRed: 241, green: 246, blue: 254)
    static let itemBackground = UIColor.white
}

enum SettingsPalette {
    static let background = UIColor(integralRed: 241, green: 246, blue: 254)
    static let itemBackground = UIColor.white
    static let itemTitle = UIColor(integralRed: 19, green: 24, blue: 42)
    static let buttonTint = UIColor(integralRed: 19, green: 24, blue: 42)
    static let unlockBackground = UIColor(integralRed: 73, green: 132, blue: 241)
    static let unlockTint = UIColor.white
}

enum CoursePalette {
    static let background = UIColor.white
}

enum PaygatePalette {
    static let background = UIColor.white
    static let continueButton = UIColor(integralRed: 73, green: 132, blue: 241)
    static let continueTint = UIColor.white
    static let primaryText = UIColor(integralRed: 19, green: 24, blue: 42)
    static let secondaryText = UIColor(integralRed: 75, green: 81, blue: 102)
    
    enum Option {
        static let selectedBackground = UIColor(integralRed: 73, green: 132, blue: 241)
        static let deselectedBorder = UIColor(integralRed: 73, green: 132, blue: 241)
        static let selectedText = UIColor.white
        static let deselectText = UIColor(integralRed: 19, green: 24, blue: 42)
        static let saveSelectedBackground = UIColor(integralRed: 254, green: 241, blue: 129)
        static let saveDeselectedBackground = UIColor.white
        static let saveSelectedText = UIColor(integralRed: 19, green: 24, blue: 42)
        static let saveDeselectedText = UIColor.white
    }
}

enum TestStatsPalette {
    static let background = UIColor(integralRed: 241, green: 246, blue: 254)
    static let primaryButton = UIColor(integralRed: 73, green: 132, blue: 241)
    static let secondaryButton = UIColor(integralRed: 222, green: 234, blue: 253)
    static let primaryText = UIColor.white
    static let secondaryText = UIColor(integralRed: 73, green: 132, blue: 241)
    static let correct = UIColor(integralRed: 157, green: 215, blue: 117)
    static let incorrect = UIColor(integralRed: 241, green: 104, blue: 91)
    static let passingScore = UIColor(integralRed: 19, green: 24, blue: 42)
    static let answerText = UIColor.white
    static let separator = UIColor(integralRed: 241, green: 246, blue: 254)
    static let loader = UIColor(integralRed: 73, green: 132, blue: 241)
    
    enum Filter {
        static let selected = UIColor(integralRed: 19, green: 24, blue: 42)
        static let deselected = UIColor(integralRed: 75, green: 81, blue: 102, alpha: 0.6)
    }
    
    enum CommunityResult {
        static let value = UIColor(integralRed: 19, green: 24, blue: 42)
        static let subtitle = UIColor(integralRed: 75, green: 81, blue: 102)
        static let separator = UIColor(integralRed: 75, green: 81, blue: 102)
    }
    
    enum Progress {
        static let text = UIColor(integralRed: 19, green: 24, blue: 42)
    }
}

enum StatsPalette {
    static let background = UIColor(integralRed: 241, green: 246, blue: 254)
    static let separator = UIColor(integralRed: 241, green: 246, blue: 254)
    
    enum Description {
        static let background = UIColor.white
        static let title = UIColor(integralRed: 19, green: 24, blue: 42)
        static let value = UIColor(integralRed: 19, green: 24, blue: 42)
    }
    
    enum Progress {
        static let testTaken = UIColor(integralRed: 73, green: 132, blue: 241)
        static let correctAnswers = UIColor(integralRed: 254, green: 187, blue: 129)
        static let questionsTaken = UIColor(integralRed: 254, green: 241, blue: 129)
    }
    
    enum MainStats {
        static let title = UIColor(integralRed: 75, green: 81, blue: 102)
        static let value = UIColor(integralRed: 19, green: 24, blue: 42)
    }
}

enum SplashPalette {
    static let background = UIColor(integralRed: 73, green: 132, blue: 241)
    static let primaryText = UIColor.white
    static let secondaryText = UIColor(integralRed: 254, green: 241, blue: 129)
}

enum Onboarding {
    static let background = UIColor.white
    static let primaryText = UIColor(integralRed: 19, green: 24, blue: 42)
    static let secondaryText = UIColor(integralRed: 75, green: 81, blue: 102)
    static let primaryButton = UIColor(integralRed: 73, green: 132, blue: 241)
    static let primaryButtonTint = UIColor.white
    static let secondaryButton = UIColor(integralRed: 241, green: 246, blue: 254)
    static let secondaryButtonBorder = UIColor.clear
    static let secondaryButtonTint = UIColor(integralRed: 73, green: 132, blue: 241)
    static let pickerText = UIColor(integralRed: 73, green: 132, blue: 241)
    
    enum LanguageAndGender {
        static let background = UIColor.white
        static let border = UIColor.clear
    }
    
    enum Goal {
        static let background = UIColor(integralRed: 241, green: 246, blue: 254)
        static let selectedBackground = UIColor(integralRed: 73, green: 132, blue: 241)
        static let text = UIColor(integralRed: 73, green: 132, blue: 241)
        static let selectedText = UIColor.white
    }
    
    enum Slider {
        static let minimumTrackTint = UIColor(integralRed: 73, green: 132, blue: 241)
        static let maximumTrackTint = UIColor(integralRed: 241, green: 246, blue: 254)
    }
    
    enum Question {
        static let containerBackground = UIColor.white
        static let text = UIColor(integralRed: 75, green: 81, blue: 102)
    }
    
    enum Preloader {
        static let text = UIColor(integralRed: 19, green: 24, blue: 42)
        static let progressTrack = UIColor(integralRed: 241, green: 246, blue: 254)
        static let progress = UIColor(integralRed: 73, green: 132, blue: 241)
    }
    
    enum Progress {
        static let track = UIColor(integralRed: 241, green: 246, blue: 254)
        static let progress = UIColor(integralRed: 73, green: 132, blue: 241)
    }
    
    enum Topics {
        static let text = UIColor(integralRed: 245, green: 245, blue: 245)
        static let selectedText = UIColor(integralRed: 31, green: 31, blue: 31)
        static let background = UIColor(integralRed: 60, green: 75, blue: 159)
        static let selectedBackground = UIColor(integralRed: 249, green: 205, blue: 106)
    }
    
    enum Plan {
        static let icon = UIColor(integralRed: 73, green: 132, blue: 241)
    }
    
    enum Locale {
        static let background = UIColor(integralRed: 241, green: 246, blue: 254)
        static let selectedBackground = UIColor(integralRed: 73, green: 132, blue: 241)
        static let text = UIColor(integralRed: 73, green: 132, blue: 241)
        static let selectedText = UIColor.white
    }
}
