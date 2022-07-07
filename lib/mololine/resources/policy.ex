defmodule Mololine.Resources.Policy do
  @behaviour Bodyguard.Policy

  def authorize(:delete_parcel, user, _parcel), do:  true#user.is_admin

end
