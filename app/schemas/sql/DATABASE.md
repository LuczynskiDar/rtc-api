# Database schema

The schema is split into two groups:
- **`base`** — required for the application to run
- **`db_evaluate`** — extended tables representing planned features, not yet used by the application

---

## Base tables

### `users`

Stores registered user accounts. Each user has a unique login name and email, a bcrypt-hashed password, and two flags controlling their status and permissions. The `is_active` flag allows disabling accounts without deleting them. The `is_superuser` flag identifies administrators.

Seed data includes 15 users: 1 admin + 14 regular users from a fictional company (`@firma.pl`). Two of them (`marek.kaminski`, `magdalena.szymanska`, `lukasz.kwiatkowski`) have `is_active = false`, simulating disabled accounts.

| Column | Purpose |
|--------|---------|
| `id` | Primary key |
| `username` | Unique login name used in API calls (e.g. `jan.kowalski`) |
| `email` | Unique email address |
| `hashed_password` | bcrypt password hash — never stored in plaintext |
| `is_active` | If `false`, user cannot log in |
| `is_superuser` | If `true`, user has admin privileges |
| `created_at` | Account creation timestamp |

---

### `streams`

Stores available video streams. Each stream has a unique name that serves as its identifier in both the RTMP push URL and the HLS playlist URL. The `file_path` points to an `.mp4` file mounted into the container under `/content/`.

Seed data: 3 streams (`film1`, `film2`, `film3`) mapped to `/content/film1.mp4` etc.

| Column | Purpose |
|--------|---------|
| `id` | Primary key |
| `name` | Unique stream key — used as `rtmp://srs:1935/live/{name}` and `http://…/live/{name}.m3u8` |
| `file_path` | Absolute path to the source video file inside the container |
| `created_at` | Record creation timestamp |

---

### `stream_access`

Controls which users are allowed to access which streams. This is a many-to-many join table between `users` and `streams`. The endpoint `GET /v1/users/{username}/streams` queries this table to return only the streams the requesting user has been granted access to.

Seed data: admin (id=1) and a few other users have access to all 3 streams; most users have access to 1–2 streams only.

| Column | Purpose |
|--------|---------|
| `id` | Primary key |
| `user_id` | FK → `users.id` — user being granted access |
| `stream_id` | FK → `streams.id` — stream being accessed |
| `granted_at` | When access was granted |
| _(constraint)_ | `UNIQUE (user_id, stream_id)` — prevents duplicate grants |

---

## Extended tables (`db_evaluate`)

> Not yet wired into the application. These tables represent a planned extension of the system toward a full streaming platform.

---

### `roles`

Defines the permission roles available in the system. Used together with `user_roles` to implement role-based access control (RBAC).

Seed data: 3 roles — `admin`, `moderator`, `viewer`.

| Column | Purpose |
|--------|---------|
| `id` | Primary key |
| `role` | Unique role name |

---

### `user_roles`

Assigns one or more roles to a user. A user can hold multiple roles simultaneously (e.g. both `moderator` and `viewer`).

Seed data: user id=1 is `admin`; users 7 and 13 are both `moderator` and `viewer`; user 2 is `viewer`.

| Column | Purpose |
|--------|---------|
| `id` | Primary key |
| `user_id` | FK → `users.id` |
| `role_id` | FK → `roles.id` |
| _(constraint)_ | `UNIQUE (user_id, role_id)` — a user holds each role at most once |

---

### `categories`

Defines content categories that can be tagged to streams. Allows filtering and browsing streams by genre.

Seed data: `akcja`, `komedia`, `dokumentalny`, `sport`, `sci-fi`.

| Column | Purpose |
|--------|---------|
| `id` | Primary key |
| `category` | Unique category name |

---

### `stream_categories`

Assigns one or more categories to a stream (many-to-many). A stream can belong to multiple categories.

Seed data: `film1` → akcja + sci-fi; `film2` → komedia + sport; `film3` → dokumentalny + akcja.

| Column | Purpose |
|--------|---------|
| `id` | Primary key |
| `stream_id` | FK → `streams.id` |
| `category_id` | FK → `categories.id` |
| _(constraint)_ | `UNIQUE (stream_id, category_id)` — no duplicate category assignments |

---

### `messages`

Stores live chat messages sent by users during a stream. Each message is linked to both the author and the stream it was posted in.

Seed data: 4 sample messages across streams, including feedback about video quality and audio sync.

| Column | Purpose |
|--------|---------|
| `id` | Primary key |
| `user_id` | FK → `users.id` — message author |
| `stream_id` | FK → `streams.id` — stream the message belongs to |
| `message` | Text content of the message |
| `message_time` | When the message was sent (timezone-aware) |

---

### `reactions`

Stores user ratings for streams on a 1–5 scale. Allows measuring viewer satisfaction per stream.

Seed data: 4 ratings — two 5-star, one 4-star, one 3-star.

| Column | Purpose |
|--------|---------|
| `id` | Primary key |
| `user_id` | FK → `users.id` — user who rated |
| `stream_id` | FK → `streams.id` — stream being rated |
| `reaction` | Integer rating 1 (lowest) to 5 (highest) |
| `created_at` | When the reaction was submitted (timezone-aware) |

---

### `days`

Links a user, a stream, and a day of the week — representing a user's recurring viewing schedule. Uses a custom PostgreSQL ENUM type `week_days` (`monday`…`sunday`).

Seed data: 14 entries spread across users 1, 7, 8, 9, 10, 12, 14, 15 on various days of the week.

| Column | Purpose |
|--------|---------|
| `id` | Primary key |
| `day` | Day of the week (ENUM: `monday`…`sunday`) |
| `user_id` | FK → `users.id` — user this schedule belongs to |
| `stream_id` | FK → `streams.id` — stream scheduled for that day |

---

### `schedule`

Defines the time window (start and stop) during which a stream is broadcast on a given day. Links to `days` to form a complete recurring schedule entry.

Seed data: 7 schedule entries across multiple streams and days, with windows ranging from 90 minutes to over 16 hours.

| Column | Purpose |
|--------|---------|
| `id` | Primary key |
| `start_stream` | Broadcast start time |
| `stop_stream` | Broadcast end time |
| `stream_id` | FK → `streams.id` — stream being broadcast |
| `day_id` | FK → `days.id` — day this time window applies to |

---

### `watch_history`

Records individual viewing sessions — when a user started and stopped watching a stream, and what percentage of it they watched. Used for analytics and resume functionality.

Seed data: 4 viewing sessions between June 15–17 2026. `view_ratio` defaults to 0 and would be updated during playback.

| Column | Purpose |
|--------|---------|
| `id` | Primary key |
| `user_id` | FK → `users.id` — viewer |
| `stream_id` | FK → `streams.id` — watched stream |
| `created_at` | When the session record was created |
| `start_time` | When the user started watching (timezone-aware) |
| `stop_time` | When the user stopped watching (timezone-aware) |
| `view_ratio` | Percentage of stream watched, 0–100 |
