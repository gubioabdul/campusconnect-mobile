# CampusConnect API Contract

The mobile application consumes the backend event endpoint defined by Project A.

- `GET /api/events` returns a JSON array of events.
- Each event contains `id`, `title`, `date`, and `attendees`.

The mobile client should treat HTTP failures as recoverable UI states rather than assuming the network is always available.