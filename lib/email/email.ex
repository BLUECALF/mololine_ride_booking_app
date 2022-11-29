defmodule Mololine.Email do
  import Mololine.Mailer
  import Bamboo.Email

  def write_email(email_address,subject,body) do
    new_email()
    |> to(email_address)
    |> from("us@example.com")
    |> subject(subject)
    |> text_body(body)
    |> deliver_later()
  end
end
