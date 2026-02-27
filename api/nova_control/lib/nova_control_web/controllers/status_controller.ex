defmodule NovaControlWeb.StatusController do
  # GARANTE QUE ESTE MODULO TENHA TODAS AS FUNCIONALIDADES DE UM CONTROLLER
  use NovaControlWeb, :controller

  # TODA ACTION RECEBE PELO MENOS 2 PARAMETROS, A CONEXÃO E OS PARAMETROS DA REQUISIÇÃO
  def index(conn, _params) do
    conn
    # DEFINE O STATUS DA RESPOSTA COMO 200 OK
    |> put_status(:ok)
    # ENVIA UMA RESPOSTA JSON
    |> json(%{status: "API is running"})
  end
end
