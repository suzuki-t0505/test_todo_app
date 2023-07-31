# TestTodoApp

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## ER図

```mermaid
erDiagram

accounts ||--o{ accounts_tokens: ""
accounts ||--o{ tasks: ""

accounts {
  integer id PK
  string email
  string hashed_password
  naive_datetime confirmed_at
  naive_datetime inserted_at
  naive_datetime updated_at
}

accounts_tokens {
  integer id PK
  integer account_id Fk
  binary token
  string context
  string sent_to
  naive_datetime inserted_at
}

tasks {
  integer id PK
  integer account_id FK
  string title
  date date
  boolean completed
  naive_datetime inserted_at
  naive_datetime updated_at
}
```
