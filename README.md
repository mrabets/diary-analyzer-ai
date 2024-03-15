[![codecov](https://codecov.io/gh/mrabets/diary-analyzer-ai/graph/badge.svg?token=G7566TBH6P)](https://codecov.io/gh/mrabets/diary-analyzer-ai)
![Build](https://github.com/mrabets/diary-analyzer-ai/actions/workflows/rubyonrails.yml/badge.svg)
![Ruby](https://img.shields.io/badge/Ruby-3.3.0-red.svg)
![Rails](https://img.shields.io/badge/Rails-7.1.3-red.svg)

# Diary Analyzer AI

<img align="right" src="/app/assets/images/logo.svg" width="150" height="auto">

**Diary Analyzer AI** is an advanced tool powered by artificial intelligence, designed for analyzing and interpreting personal diary entries. It provides users with valuable insights from their daily recordings, identifying key themes, moods, and recommendations, aiding in better self-understanding and personal growth.

**Visit the project here: [diaryanalyzer.com](https://diaryanalyzer.com)**

### Features
- **Mood Analysis**: Identifies the overall mood of the diary entries (positive, negative, neutral).
- **Theme Detection**: Highlights key themes and topics covered in the entries.
- **Personalized Recommendations**: Offers actionable advice and recommendations based on the analysis of diary entries.

## Technologies Used

This project is built with a number of cutting-edge technologies and frameworks to ensure high performance and reliability:

- Programming Language: **Ruby 3.3.0**
- Web Application Framework: **Rails 7.1.3**
- AI & Machine Learning: Utilizes the **OpenAI API** for analyzing text and extracting insights.
- HTTP Client: **Faraday** for making network requests to external APIs.
- Authentication: **OAuth 2.0** with **Omniauth** for secure user authentication through external providers.
- Jobs: **ActionMailer** with **Sidekiq** for sending emails from the application.
- Real-Time Web: **ActionCable** for real-time features in Rails applications.
- Payments: **Stripe** for processing payments securely.
- Database: **PostgreSQL** for relational data storage and **ElasticSearch** for efficient, full-text search capabilities.
- Frontend: Employs **Hotwire** (**Turbo & Stimulus**) for a modern, interactive user experience without the need for complex JavaScript frameworks.
- Deployment: Hosted on **DigitalOcean** using **Kamal**.


## Usage

#### Create `.env` file with the following variables:

```
POSTGRES_USERNAME=<your_postgres_username>
POSTGRES_PASSWORD=<your_postgres_password
DB_HOST=localhost

KAMAL_REGISTRY_PASSWORD=<your_dockerhub_access_token>
RAILS_MASTER_KEY=<your_rails_master_key> # config/master.key
SECRET_KEY_BASE=<your_secret_key_base> # generate with `rails secret`

SERVER_HOST=<your_server_host>
SENDGRID_API_KEY=<your_sendgrid_api_key>
REDIS_URL=<your_redis_url> # e.g. redis://<your_server_host>:6379/0
ELASTICSEARCH_URL=<your_elasticsearch_url> # e.g. http://<your_server_host>:9200

STRIPE_PUBLISHABLE_KEY=<your_stripe_publishable_key>
STRIPE_SECRET_KEY=<your_stripe_secret_key>
STRIPE_ENDPOINT_SECRET=<your_stripe_webhook_secret> # e.g. whsec_...
STRIPE_SUBSCRIPTION_PLAN_ID=<your_stripe_subscription_plan_id> # e.g. price_...

OPEN_AI_API_KEY=<your_openai_api_key> # e.g sk-...
```

OAuth2 credentials for Google and Facebook are required for user authentication. Generate Rails credentials with `rails credentials:edit` and add the following:

```
google:
  client_id: your_google_client_id
  client_secret: your_google_client_secret

github:
  client_id: your_github_client_id
  client_secret: your_github_client_secret
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
