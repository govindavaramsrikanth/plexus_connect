# plexus_connect

A customizable Flutter widget that renders dynamic **plexus-style particle animations** — animated nodes connected by lines — perfect for tech-inspired splash screens, loading backgrounds, and modern UI flair.

![plexus_demo](https://github.com/govindavaramsrikanth/plexus_connect/blob/main/assets/plexus_demo.gif)

---

## ✨ Features

- 🎯 Customizable point count, size, color, and speed
- 🔗 Dynamic line drawing between nearby points
- 🎨 Control over background color and max connection distance
- 📱 Responsive and efficient using `CustomPainter`
- 🧩 Easy to embed into any widget tree

---

## 🚀 Getting Started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  plexus_connect: ^1.0.0


```
Then import it in your Dart code:

import 'package:plexus_connect/plexus_connect.dart';

## Usage
Here's a basic example showing how to use the PlexusAnimation widget:

const PlexusAnimation(
pointCount: 30, // Number of animated points
maxDistance: 150, // Maximum distance for line connections
animationSpeed: 0.03, // Wave animation speed
allowTouchInteraction: true, // Enable user touch interaction
pointColor: Colors.redAccent, // Color of each point
lineStartColor: Colors.green, // Gradient start color for lines
lineEndColor: Colors.purple, // Gradient end color for lines
),

## Additional information

| Parameter               | Type     | Default         | Description                                     |
|-------------------------|----------|-----------------|-------------------------------------------------|
| `pointCount`            | `int`    | `40`            | Number of animated points                       |
| `maxDistance`           | `double` | `150`           | Maximum distance for line connections           |
| `animationSpeed`        | `double` | `2.0`           | Wave animation speed                            |
| `allowTouchInteraction` | `bool`   | `true`          | Enable user touch interaction                   |
| `pointColor`            | `Color`  | `Colors.white`  | Color of each point                             |
| `lineStartColor`        | `Color`  | `Colors.black`  | Gradient start color for lines                  |
| `lineEndColor`          | `Color`  | `Colors.purple` | Max distance between nodes to draw a connection |

GitHub: github.com/govindavaramsrikanth/plexus_connect

Maintained by Srikanth Govindavaram

Contributions are welcome! Feel free to file issues or submit PRs.

