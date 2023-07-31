alias TestTodoApp.Repo
alias TestTodoApp.Accounts.Account

users = ~w(user01 user02)

Enum.each(users, fn user ->
  Repo.insert!(
    %Account{
      email: user <> "@sample.com",
      hashed_password: Bcrypt.hash_pwd_salt(user <> "999"),
      confirmed_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
    }
  )
end)
