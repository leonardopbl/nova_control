defmodule NovaControlWeb.Auth.AccessPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :nova_control,
    module: NovaControl.Auth.Guardian,
    error_handler: NovaControlWeb.Auth.ErrorHandler

  plug(Guardian.Plug.VerifyHeader, scheme: "Bearer")
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end
