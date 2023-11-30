# Diary Analyzer AI

<img align="right" src="/app/assets/images/logo.png" width="150" height="auto">

**Diary Analyzer AI** is an advanced tool powered by artificial intelligence, designed for analyzing and interpreting personal diary entries. It provides users with valuable insights from their daily recordings, identifying key themes, moods, and trends, aiding in better self-understanding and personal growth.

### Features
- **Mood Analysis**: Identifies the overall mood of the diary entries (positive, negative, neutral).
- **Theme Detection**: Highlights key themes and topics covered in the entries.
- **Trend Analysis**: Tracks changes in mood and themes over time, offering a broader perspective on the user's thoughts and feelings.

## Usage
This API can be integrated into personal diary applications, mental health tracking apps, or any platform where users record their daily thoughts and feelings.

Check out the [API docs](https://gist.github.com/mrabets/04362900778be23f9ed8c271483456c0)

#### Create `.env` file with the following variables:

```
POSTGRES_USERNAME=<your_postgres_username>
POSTGRES_PASSWORD=<your_postgres_password
DB_HOST=localhost

KAMAL_REGISTRY_PASSWORD=<your_dockerhub_access_token>
RAILS_MASTER_KEY=<your_rails_master_key> # config/master.key
SECRET_KEY_BASE=<your_secret_key_base> # generate with `rails secret`
```

#### Run locally

```bash
bin/rails db:create db:schema:load
bin/rails s
```

#### Run with Docker

```bash
docker-compose build
docker-compose run web bundle exec rails db:create db:schema:load
docker-compose up
```

## License
Diary Analyzer AI is released under the [MIT License](LICENSE).