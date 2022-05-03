defmodule FitlogWeb.ReportControllerTest do
  use FitlogWeb.ConnCase

  import Fitlog.ReportsFixtures
  import Fitlog.UsersFixtures

  alias Fitlog.Reports.Report

  @create_attrs %{
    calories: 1200,
    carbs: "120.5",
    date: ~D[2022-01-16],
    dumbbell_sets: 9,
    pullups: 20,
    fat: "120.5",
    protein: "120.5",
    stepper: 42,
    steps: 42,
    weight: "120.5"
  }
  @update_attrs %{
    calories: 1500,
    carbs: "456.7",
    date: ~D[2022-01-17],
    dumbbell_sets: 10,
    pullups: 25,
    fat: "456.7",
    protein: "456.7",
    stepper: 43,
    steps: 43,
    weight: "456.7"
  }
  @invalid_attrs %{
    calories: nil,
    carbs: nil,
    date: nil,
    dumbbell_sets: nil,
    pullups: nil,
    fat: nil,
    protein: nil,
    stepper: nil,
    steps: nil,
    weight: nil
  }

  defp login(conn, user) do
    Fitlog.Users.Guardian.Plug.sign_in(conn, user)
    |> Guardian.Plug.VerifySession.call([])
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_report]

    test "lists user reports", %{conn: conn, user: user} do
      conn_with_user = login(conn, user)

      conn = get(conn_with_user, Routes.report_path(conn, :index))

      assert json_response(conn, 200)
    end
  end

  describe "create report" do
    test "renders report when data is valid", %{conn: conn} do
      conn_with_user = login(conn, user_fixture())
      report = post(conn_with_user, Routes.report_path(conn, :create), report: @create_attrs)

      assert %{"id" => id} = json_response(report, 201)["data"]

      conn = get(conn_with_user, Routes.report_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "calories" => 1200,
               "carbs" => "120.5",
               "date" => "2022-01-16",
               "dumbbell_sets" => 9,
               "fat" => "120.5",
               "protein" => "120.5",
               "stepper" => 42,
               "steps" => 42,
               "weight" => "120.5"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn_with_user = login(conn, user_fixture())
      conn = post(conn_with_user, Routes.report_path(conn, :create), report: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update report" do
    setup [:create_report]

    test "renders report when data is valid", %{
      conn: conn,
      report: %Report{id: id} = report,
      user: user
    } do
      conn_with_user = login(conn, user)

      report =
        put(conn_with_user, Routes.report_path(conn, :update, report), report: @update_attrs)

      assert %{"id" => ^id} = json_response(report, 200)["data"]

      conn = get(conn_with_user, Routes.report_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "calories" => 1500,
               "carbs" => "456.7",
               "date" => "2022-01-17",
               "dumbbell_sets" => 10,
               "fat" => "456.7",
               "protein" => "456.7",
               "stepper" => 43,
               "steps" => 43,
               "weight" => "456.7"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, report: report, user: user} do
      conn_with_user = login(conn, user)

      conn =
        put(conn_with_user, Routes.report_path(conn, :update, report), report: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete report" do
    setup [:create_report]

    test "deletes chosen report", %{conn: conn, report: report, user: user} do
      conn_with_user = login(conn, user)

      delete_conn = delete(conn_with_user, Routes.report_path(conn, :delete, report))
      assert response(delete_conn, 204)

      assert_error_sent 404, fn ->
        get(conn_with_user, Routes.report_path(conn, :show, report))
      end
    end
  end

  defp create_report(_) do
    user = user_fixture()
    report = report_fixture(user)
    %{report: report, user: user}
  end
end
