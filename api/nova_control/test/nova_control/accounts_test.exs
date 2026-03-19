defmodule NovaControl.AccountsTest do
  use NovaControl.DataCase, async: true

  alias NovaControl.Accounts

  describe "create_user/2" do
    test "creates an expense with valid attrs" do
      {:ok, %{register: register, user: user}} =
        Accounts.create_user(
          %{
            name: "John Doe",
            email: "john.doe@email.com",
            phone: "41999999999",
            birth_date: ~D[1990-01-01]
          },
          "password123"
        )

      assert user.id != nil
      assert user.name == "John Doe"
      assert user.email == "john.doe@email.com"
      assert user.phone == "41999999999"
      assert user.birth_date == ~D[1990-01-01]
      assert register.provider != nil
      assert register.password_hash != Bcrypt.hash_pwd_salt("password123")
      assert register.user_id == user.id
    end

    test "returns invalid_user when user attrs are invalid" do
      user_attrs = %{
        "name" => "ab",
        "email" => "invalid",
        "phone" => "123",
        "birth_date" => ~D[1990-01-01]
      }

      assert {:error, :invalid_user, changeset} =
               Accounts.create_user(user_attrs, "12345")

      errors = errors_on(changeset)
      assert "has invalid format" in errors.email
    end

    test "returns invalid_register when password is valid" do
      user_attrs = %{
        "name" => "John Doe",
        "email" => "john.doe@email.com",
        "phone" => "41999999999"
      }

      assert {:error, :invalid_register, changeset} =
               Accounts.create_user(user_attrs, "123")

      errors = errors_on(changeset)
      assert "should be at least 8 character(s)" in errors.password
    end
  end

  describe "update_user/2" do
    test "update a existing user with valid attrs" do
      {:ok, %{user: user}} =
        Accounts.create_user(
          %{
            name: "John Doe",
            email: "john.doe@email.com",
            phone: "41999999999",
            birth_date: ~D[1990-01-01]
          },
          "password123"
        )

      assert {:ok, updated_user} =
               Accounts.update_user(user.id, %{
                 "name" => "Zé ninguém",
                 "phone" => "41888888888"
               })

      assert updated_user.name == "Zé ninguém"
      assert updated_user.phone == "41888888888"
    end

    test "returns not_found when user does not exist" do
      assert {:error, :not_found} =
               Accounts.update_user(-1, %{"name" => "Any Name"})
    end

    test "returns no_valid_fields when attrs have no allowed fields" do
      {:ok, %{user: user}} =
        Accounts.create_user(
          %{
            "name" => "John Doe",
            "email" => "john.doe@email.com",
            "phone" => "41999999999"
          },
          "12345678"
        )

      assert {:error, :no_valid_fields} =
               Accounts.update_user(user.id, %{"unknown_field" => "value"})
    end

    test "returns changeset error when attrs are invalid" do
      {:ok, %{user: user}} =
        Accounts.create_user(
          %{
            "name" => "John Doe",
            "email" => "invalid-update@email.com",
            "phone" => "41999999999"
          },
          "12345678"
        )

      assert {:error, changeset} = Accounts.update_user(user.id, %{"email" => "not-an-email"})

      errors = errors_on(changeset)
      assert "has invalid format" in errors.email
    end
  end

  describe "list_users" do
    test "return all users" do
      {:ok, %{user: user1}} =
        Accounts.create_user(
          %{
            name: "John Doe First",
            email: "john.doe.first@email.com",
            phone: "41999999999",
            birth_date: ~D[1990-01-01]
          },
          "password123"
        )

      {:ok, %{user: user2}} =
        Accounts.create_user(
          %{
            name: "John Doe Second",
            email: "john.doe.second@email.com",
            phone: "41999999999",
            birth_date: ~D[1990-01-01]
          },
          "password123"
        )

      users = Accounts.list_users()
      ids = Enum.map(users, & &1.id)

      assert length(users) == 2
      assert user1.id in ids
      assert user2.id in ids
    end
  end

  describe "get_user/1" do
    test "return single user by id" do
      {:ok, %{user: user}} =
        Accounts.create_user(
          %{
            name: "John Doe",
            email: "john.doe@email.com",
            phone: "41999999999",
            birth_date: ~D[1990-01-01]
          },
          "password123"
        )

      singleUser = Accounts.get_user(user.id)

      assert singleUser.name == user.name
      assert singleUser.email == user.email
      assert singleUser.phone == user.phone
      assert singleUser.birth_date == user.birth_date
    end
  end

  describe "delete_user/1" do
    test "delete a user by id" do
      {:ok, %{user: user}} =
        Accounts.create_user(
          %{
            name: "John Doe",
            email: "john.doe@email.com",
            phone: "41999999999",
            birth_date: ~D[1990-01-01]
          },
          "password123"
        )

      Accounts.delete_user(user.id)

      assert Accounts.get_user(user.id) == nil
    end
  end

  describe "authenticate_user/2" do
    test "login a user with valid credentials" do
      {:ok, %{user: user}} =
        Accounts.create_user(
          %{
            name: "John Doe",
            email: "john.doe@email.com",
            phone: "41999999999",
            birth_date: ~D[1990-01-01]
          },
          "password123"
        )

      assert {:ok, authenticated_user} = Accounts.authenticate_user(user.email, "password123")
      assert authenticated_user.name == user.name
      assert authenticated_user.email == user.email
    end
  end
end
