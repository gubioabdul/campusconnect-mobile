# CampusConnect Mobile Architecture

The Flutter client is intentionally thin. It loads event data from the CampusConnect Express API and presents the data in a native mobile interface.

## Flow

Flutter UI -> HTTP client -> Express API -> event data

Keeping the mobile client separate from backend responsibilities makes the application easier to test and maintain.