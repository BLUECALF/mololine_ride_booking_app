defmodule Mololine.Resources.Policy do
  @behaviour Bodyguard.Policy

  def authorize(:delete_parcel, user, _parcel), do: user.is_admin

end
