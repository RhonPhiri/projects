# nah
## Description
New Apostolic Church Hymnal is a lightweight, offline hymnal app created with flutter (Beginner level). It includes hymns in various languages including English, with a focus on simplicity, accessibility, and ease of use.

The app offers:

    - A collection of traditional and local-language hymns

    - Full-screen reading for distraction-free use

    - Dark mode for comfortable night-time reading

    - Search and bookmark functionality for quick access

It is intended as a helpful companion when a physical hymnal isn’t available—not as a replacement. All bookmarks and preferences are stored locally on user's device.
--

## Project Structure
This project tries to follow the feature first app architecture as described under [Flutter Architectural Case Study](https://docs.flutter.dev/app-architecture/case-study)

Here is the overview
```
    lib
├─┬─ ui
│ ├─┬─ core
│ │ ├─┬─ ui
│ │ │ └─── <shared widgets>
│ │ └─── themes
│ └─┬─ <FEATURE NAME>
│   ├─┬─ view_model
│   │ └─── <view_model class>.dart
│   └─┬─ widgets
│     ├── <feature name>_screen.dart
│     └── <other widgets>
├─┬─ domain
│ └─┬─ models
│   └─── <model name>.dart
├─┬─ data
│ ├─┬─ repositories
│ │ └─── <repository class>.dart
│ ├─┬─ services
│ │ └─── <service class>.dart
│ └─┬─ model
│   └─── <api model class>.dart
├─── config
├─── utils
├─── routing
├─── main_staging.dart
├─── main_development.dart
└─── main.dart

// The test folder contains unit and widget tests
test
├─── data
├─── domain
├─── ui
└─── utils

// The testing folder contains mocks other classes need to execute tests
testing
├─── fakes
└─── models
