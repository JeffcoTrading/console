defmodule ConsoleWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: ConsoleWeb.Schema

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"token" => token}, socket) do
    case Guardian.Phoenix.Socket.authenticate(socket, ConsoleWeb.Guardian, token) do
      {:ok, authed_socket} ->
        authed_socket = Absinthe.Phoenix.Socket.put_options(authed_socket, context: %{
          current_team_id: authed_socket.assigns.guardian_default_claims["team"],
          current_organization_id: authed_socket.assigns.guardian_default_claims["organization"]
        })
        {:ok, authed_socket}

      {:error, _} ->
        :error
    end
  end

  def connect(_params, socket) do
    :error
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     ConsoleWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
