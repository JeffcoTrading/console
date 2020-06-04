defmodule ConsoleWeb.OrganizationControllerTest do
  use ConsoleWeb.ConnCase

  import Console.FactoryHelper
  import Console.Factory

  alias Console.Organizations

  describe "invitations" do
    setup [:authenticate_user]

    test "create organization properly", %{conn: conn} do
      resp_conn = post conn, organization_path(conn, :create), %{ "organization" => %{ "name" => "yes org" }}
      organization = json_response(resp_conn, 201)

      current_user = resp_conn.assigns.current_user
      assert Organizations.get_membership!(current_user, Organizations.get_organization!(organization["id"])) != nil
    end

    test "delete organization properly", %{conn: conn} do
      resp_conn = post conn, organization_path(conn, :create), %{ "organization" => %{ "name" => "yes org" }}
      organization = json_response(resp_conn, 201)
      current_user = resp_conn.assigns.current_user

      resp_conn = delete conn, organization_path(conn, :delete, organization["id"])
      assert response(resp_conn, 202) # delete own org successfully

      another_org = insert(:organization)
      assert_error_sent 404, fn ->
        resp_conn = delete conn, organization_path(conn, :delete, another_org.id)
      end # cannot delete other orgs

      another_membership = insert(:membership, %{ organization_id: another_org.id, user_id: current_user.id, email: current_user.email, role: "read" })
      resp_conn = delete conn, organization_path(conn, :delete, another_org.id)
      assert response(resp_conn, 403) # cannot delete org if user is not admin
    end
  end
end