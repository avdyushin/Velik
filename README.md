# Velik.app
## Ride tracking iOS app

Build in SwiftUI using Combine and CoreData

### Features

- Track current location and draw path on the map
- Show current/average speed, distance and duration of the ride
- Adjustable size on the map and gauges view
- Calculates estimated average power effort and weight loss
- Imports GPX files into rides with summary
- Exports rides as GPX
- Light/Dark mode

### Limitations

1. Drag'n'drop files into iOS Simulator works only from $HOME directory
1. Xcode location simulation works only with waypoints GPX files

### GPX processing

pbpaste > debug.gpx
xmllint --format input.xml > output.xml
awk -f gpx_fix input.gpx > output.gpx

### Dependencies

- https://github.com/avdyushin/CoreDataStorage
- https://github.com/avdyushin/Injected
- https://github.com/avdyushin/Localizable
- https://github.com/avdyushin/PageView
- https://github.com/avdyushin/SplitView
