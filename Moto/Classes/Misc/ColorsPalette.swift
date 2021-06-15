//
//  ColorsPalette.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 06.05.2021.
//

import UIKit

enum NavigationPalette {
    static let navigationBackground = UIColor.white
    static let navigationTint = UIColor(integralRed: 31, green: 31, blue: 31)
    static let navigationTrackTint = UIColor(integralRed: 237, green: 237, blue: 237)
    static let navigationProgressTint = UIColor(integralRed: 255, green: 101, blue: 1)
    static let tabTint = UIColor(integralRed: 31, green: 31, blue: 31)
    static let tabBarBackground = UIColor.white
}

enum TrophyPalette {
    static let background = UIColor(integralRed: 1, green: 163, blue: 131)
    static let title = UIColor.white
    static let buttonTint = UIColor.white
    static let buttonBackground = UIColor.clear
}

enum StudyPalette {
    static let background = UIColor.white
    static let primaryButton = UIColor(integralRed: 31, green: 31, blue: 31)
    static let secondaryButton = UIColor(integralRed: 237, green: 237, blue: 237)
    static let primaryButtonText = UIColor.white
    static let secondaryButtonText = UIColor(integralRed: 31, green: 31, blue: 31)
    static let title = UIColor(integralRed: 31, green: 31, blue: 31)
    
    enum Brief {
        static let selected = UIColor(integralRed: 255, green: 101, blue: 1)
        static let text = UIColor(integralRed: 31, green: 31, blue: 31)
        static let selectedText =  UIColor.white
        static let weekdayText = UIColor(integralRed: 68, green: 68, blue: 68, alpha: 0.5)
    }
    
    enum Course {
        static let selected = UIColor(integralRed: 255, green: 101, blue: 1)
        static let deselected = UIColor(integralRed: 237, green: 237, blue: 237)
        static let title = UIColor(integralRed: 31, green: 31, blue: 31)
        static let subtitle = UIColor(integralRed: 68, green: 68, blue: 68)
        static let selectedText = UIColor.white
        // Нет компонента
        static let addCourse = UIColor(integralRed: 232, green: 234, blue: 237)
        static let progressText = UIColor(integralRed: 31, green: 31, blue: 31)
    }
    
    enum Mode {
        static let background = UIColor(integralRed: 237, green: 237, blue: 237)
        static let iconBackground = UIColor(integralRed: 31, green: 31, blue: 31)
        static let iconTint = UIColor.white
        static let markBackground = UIColor(integralRed: 255, green: 101, blue: 1)
        static let markText = UIColor.white
        static let title = UIColor(integralRed: 31, green: 31, blue: 31)
    }
}

enum TimedExamPalette {
    static let background = UIColor.white
    static let title = UIColor(integralRed: 68, green: 68, blue: 68)
    static let subtitle = UIColor(integralRed: 31, green: 31, blue: 31)
    static let closeTint = UIColor(integralRed: 31, green: 31, blue: 31)
    static let startButton = UIColor(integralRed: 31, green: 31, blue: 31)
    static let startButtonTint = UIColor.white
}

enum ScorePalette {
    static let background = UIColor(integralRed: 255, green: 101, blue: 1)
    static let containerBackground = UIColor.white
    static let title = UIColor.white
    static let progress = UIColor(integralRed: 68, green: 68, blue: 68)
    static let progressWarning = UIColor(integralRed: 239, green: 82, blue: 67)
}

enum TestPalette {
    static let background = UIColor(integralRed: 237, green: 237, blue: 237)
    static let primaryButton = UIColor(integralRed: 31, green: 31, blue: 31)
    static let secondaryButton = UIColor(integralRed: 31, green: 31, blue: 31)
    static let primaryTint = UIColor.white
    static let secondaryTint = UIColor.white
    static let questionText = UIColor(integralRed: 31, green: 31, blue: 31)
    static let explanationTitle = UIColor(integralRed: 31, green: 31, blue: 31)
    static let explanationText = UIColor(integralRed: 68, green: 68, blue: 68)
    static let bottomGradients = [UIColor.clear].map { $0.cgColor }
    
    enum Answer {
        static let text = UIColor(integralRed: 68, green: 68, blue: 68)
        static let selectedText = UIColor.white
        static let selectedBorder = UIColor(integralRed: 255, green: 101, blue: 1)
        static let initialBorder = UIColor.clear
        static let warningBorder = UIColor(integralRed: 143, green: 209, blue: 97)
        static let initialBackground = UIColor.white
        static let incorrectBackground = UIColor(integralRed: 239, green: 82, blue: 67)
        static let correctBackground = UIColor(integralRed: 143, green: 209, blue: 97)
        static let warningBackground = UIColor.white
    }
    
    enum QuestionNumber {
        static let background = UIColor.white
        static let text = UIColor(integralRed: 31, green: 31, blue: 31)
        static let selectedBackground = UIColor(integralRed: 255, green: 101, blue: 1)
        static let selectedText = UIColor.white
    }
}

enum CourseDetailsPalette {
    static let primaryButton = UIColor.white
    static let primaryTint = UIColor(integralRed: 68, green: 68, blue: 68)
    // Не используется
    static let secondaryButton = UIColor(integralRed: 41, green: 55, blue: 137)
    // Не используется
    static let secondaryTint = UIColor(integralRed: 245, green: 245, blue: 245)
    static let correctGradient = UIColor(integralRed: 143, green: 209, blue: 97)
    static let incorrectGradient = UIColor(integralRed: 239, green: 82, blue: 67)
    static let emptyGradient = UIColor(integralRed: 237, green: 237, blue: 237)
    static let title = UIColor(integralRed: 31, green: 31, blue: 31)
    static let subtitle = UIColor(integralRed: 68, green: 68, blue: 68, alpha: 0.6)
    static let background = UIColor(integralRed: 237, green: 237, blue: 237)
    static let itemBackground = UIColor.white
}

enum SettingsPalette {
    static let background = UIColor(integralRed: 237, green: 237, blue: 237)
    static let itemBackground = UIColor.white
    static let itemTitle = UIColor(integralRed: 31, green: 31, blue: 31)
    static let buttonTint = UIColor(integralRed: 31, green: 31, blue: 31)
    static let unlockBackground = UIColor(integralRed: 255, green: 101, blue: 1)
    static let unlockTint = UIColor.white
}

enum CoursePalette {
    static let background = UIColor.white
}

enum PaygatePalette {
    static let background = UIColor.white
    static let continueButton = UIColor(integralRed: 31, green: 31, blue: 31)
    static let continueTint = UIColor.white
    static let primaryText = UIColor(integralRed: 31, green: 31, blue: 31)
    static let secondaryText = UIColor(integralRed: 68, green: 68, blue: 68)
    
    enum Option {
        static let selectedBackground = UIColor(integralRed: 255, green: 101, blue: 1)
        static let deselectedBorder = UIColor(integralRed: 255, green: 101, blue: 1)
        static let selectedText = UIColor.white
        static let deselectText = UIColor(integralRed: 19, green: 24, blue: 42)
        static let saveSelectedBackground = UIColor.white
        static let saveDeselectedBackground = UIColor.white
        static let saveSelectedText = UIColor(integralRed: 19, green: 24, blue: 42)
        static let saveDeselectedText = UIColor(integralRed: 19, green: 24, blue: 42)
    }
}

enum TestStatsPalette {
    static let background = UIColor(integralRed: 237, green: 237, blue: 237)
    static let primaryButton = UIColor(integralRed: 31, green: 31, blue: 31)
    static let secondaryButton = UIColor(integralRed: 212, green: 212, blue: 212)
    static let primaryText = UIColor.white
    static let secondaryText = UIColor(integralRed: 31, green: 31, blue: 31)
    static let correct = UIColor(integralRed: 143, green: 209, blue: 97)
    static let incorrect = UIColor(integralRed: 239, green: 82, blue: 67)
    static let passingScore = UIColor(integralRed: 31, green: 31, blue: 31)
    static let answerText = UIColor.white
    static let separator = UIColor(integralRed: 237, green: 237, blue: 237)
    static let loader = UIColor(integralRed: 255, green: 101, blue: 1)
    
    enum Filter {
        static let selected = UIColor(integralRed: 31, green: 31, blue: 31)
        static let deselected = UIColor(integralRed: 68, green: 68, blue: 68, alpha: 0.6)
    }
    
    enum CommunityResult {
        static let value = UIColor(integralRed: 31, green: 31, blue: 31)
        static let subtitle = UIColor(integralRed: 31, green: 31, blue: 31)
        static let separator = UIColor(integralRed: 68, green: 68, blue: 68, alpha: 0.2)
    }
    
    enum Progress {
        static let text = UIColor(integralRed: 31, green: 31, blue: 31)
    }
}

enum StatsPalette {
    static let background = UIColor(integralRed: 237, green: 237, blue: 237)
    static let separator = UIColor(integralRed: 241, green: 246, blue: 254)
    
    enum Description {
        static let background = UIColor.white
        static let title = UIColor(integralRed: 19, green: 24, blue: 42)
        static let value = UIColor(integralRed: 19, green: 24, blue: 42)
    }
    
    enum Progress {
        static let testTaken = UIColor(integralRed: 31, green: 31, blue: 31)
        static let correctAnswers = UIColor(integralRed: 255, green: 101, blue: 1)
        static let questionsTaken = UIColor(integralRed: 1, green: 163, blue: 131)
    }
    
    enum MainStats {
        static let title = UIColor(integralRed: 68, green: 68, blue: 68)
        static let value = UIColor(integralRed: 31, green: 31, blue: 31)
    }
}

enum SplashPalette {
    static let background = UIColor(integralRed: 255, green: 101, blue: 1)
    static let primaryText = UIColor.white
    static let secondaryText = UIColor(integralRed: 31, green: 31, blue: 31)
}

enum Onboarding {
    static let background = UIColor.white
    static let primaryText = UIColor(integralRed: 31, green: 31, blue: 31)
    static let secondaryText = UIColor(integralRed: 68, green: 68, blue: 68)
    static let primaryButton = UIColor(integralRed: 31, green: 31, blue: 31)
    static let primaryButtonTint = UIColor.white
    static let secondaryButton = UIColor(integralRed: 237, green: 237, blue: 237)
    static let secondaryButtonBorder = UIColor.clear
    static let secondaryButtonTint = UIColor(integralRed: 31, green: 31, blue: 31)
    static let pickerText = UIColor(integralRed: 255, green: 101, blue: 1)
    
    enum LanguageAndGender {
        static let background = UIColor.white
        static let border = UIColor.clear
    }
    
    enum Goal {
        static let background = UIColor(integralRed: 253, green: 246, blue: 241)
        static let selectedBackground = UIColor(integralRed: 255, green: 101, blue: 1)
        static let text = UIColor(integralRed: 255, green: 101, blue: 1)
        static let selectedText = UIColor.white
    }
    
    enum Slider {
        static let minimumTrackTint = UIColor(integralRed: 255, green: 101, blue: 1)
        static let maximumTrackTint = UIColor(integralRed: 237, green: 237, blue: 237)
    }
    
    enum Question {
        static let containerBackground = UIColor.white
        static let text = UIColor.white
    }
    
    enum Preloader {
        static let background = UIColor(integralRed: 255, green: 101, blue: 1)
        static let text = UIColor.white
        static let progressTrack = UIColor(integralRed: 255, green: 147, blue: 76)
        static let progress = UIColor.white
    }
    
    enum Progress {
        static let track = UIColor(integralRed: 237, green: 237, blue: 237)
        static let progress = UIColor(integralRed: 255, green: 101, blue: 1)
    }
    
    enum Topics {
        static let text = UIColor(integralRed: 245, green: 245, blue: 245)
        static let selectedText = UIColor(integralRed: 31, green: 31, blue: 31)
        static let background = UIColor(integralRed: 60, green: 75, blue: 159)
        static let selectedBackground = UIColor(integralRed: 249, green: 205, blue: 106)
    }
    
    enum Plan {
        static let icon = UIColor(integralRed: 255, green: 101, blue: 1)
    }
    
    enum Locale {
        static let background = UIColor(integralRed: 253, green: 246, blue: 241)
        static let selectedBackground = UIColor(integralRed: 255, green: 101, blue: 1)
        static let text = UIColor(integralRed: 255, green: 101, blue: 1)
        static let selectedText = UIColor.white
    }
}

enum FlashcardPalette {
    static let background = UIColor(integralRed: 237, green: 237, blue: 237)
    
    enum Card {
        static let background = UIColor.white
        static let progress = UIColor(integralRed: 68, green: 68, blue: 68)
        static let question = UIColor(integralRed: 31, green: 31, blue: 31)
        static let answer = UIColor(integralRed: 68, green: 68, blue: 68)
        static let buttonTintSelected = UIColor.white
        static let buttonTintDeselected = UIColor(integralRed: 31, green: 31, blue: 31)
        static let selectedButton = UIColor(integralRed: 31, green: 31, blue: 31)
        static let initialButton = UIColor(integralRed: 237, green: 237, blue: 237)
    }
}
