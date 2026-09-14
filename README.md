## PlanEat: mood-based AI meal planner for iOS

PlanEat is an iOS app built with SwiftUI, Firebase, and the OpenAI API. It asks how you feel each day and suggests breakfast, lunch, dinner, and a snack to match, with calories and ingredients for each meal. Your profile (age, goals, health conditions) shapes the suggestions, and everything you log is saved to your account.

## Demo

https://github.com/user-attachments/assets/6f5f7f04-452e-4484-bd19-f5cb4392a57f

The demo runs in the iOS Simulator. The meals and photos shown are the app's built-in fallback content, which appears whenever the OpenAI API is unavailable. The project does not currently have API credits, so the live path is not active in this recording. With a key and credits, meal text comes from GPT-4o mini and meal images from DALL-E 3, and the same screens show the generated results.

## What it does

**Mood check-in.** Pick one of four faces and a few words that describe your day. The suggestions for that day change based on what you chose, and the calendar keeps a record of your moods.

**Daily meal suggestions.** The app asks the OpenAI API for a breakfast, lunch, dinner, and snack that fit your profile and mood, then shows each one with a calorie range and main ingredients. You can regenerate a meal you don't like. If the API is unreachable, the app falls back to a built-in set of meals so the screen never ends up empty.

**Nutrition summary.** A daily protein, fat, and carb breakdown with a calorie ring, updated as meals change.

**Profile and goals.** Date of birth, goal (weight loss, muscle gain, maintenance, detox), and special conditions (diabetes, hypertension, allergies, or none) are stored per user and passed into every request.

**Accounts.** Sign up, log in, reset your password, and edit your profile. Firebase Auth handles login; Cloud Firestore stores moods, meals, and preferences.

## Tech stack

| Part | Tools |
|------|-------|
| iOS app | Swift, SwiftUI |
| Auth and data | Firebase Authentication, Cloud Firestore |
| AI | OpenAI API (GPT-4o mini for meal text, DALL-E 3 for meal images) |
| Design | Figma |
| Fonts | Baloo Bhaijaan 2 for headings and subheads, Gamja Flower for body text (both from Google Fonts, bundled in the app)|

## Team

- **Jimin Kim**: UI design in Figma and the SwiftUI front-end (all screens, navigation, loading and fallback states, image caching).
- **Seyeon Bark**: full-stack development, Firebase setup, OpenAI integration.
- **David Kim**: full-stack development, Firebase setup, OpenAI integration.

## Running it locally

1. Clone the repo and open `PlanEat.xcodeproj` in Xcode 26 or later.
2. Add your own `GoogleService-Info.plist` from a Firebase project with Auth and Firestore enabled.
3. Add an OpenAI API key (see `AIService.swift` for where it is read).
4. Pick an iPhone simulator and press Run.

## What's next

- Apple Health integration so calorie targets can follow real activity.
- Reminders and a short weekly feedback survey.
- An App Store release once image generation is funded.
