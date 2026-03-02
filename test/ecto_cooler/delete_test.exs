defmodule EctoCooler.DeleteTestContext.People do
  @moduledoc false

  alias EctoCooler.TestRepo
  alias EctoCooler.TestSchema.Person

  use EctoCooler

  using_repo TestRepo do
    resource(Person, :delete)
  end
end

defmodule EctoCooler.DeleteTest do
  use EctoCooler.RepoCase

  alias EctoCooler.TestSchema.Person
  alias EctoCooler.DeleteTestContext.People

  @person_attributes %{
    first_name: "Test",
    last_name: "Person",
    age: 42
  }

  describe "all" do
    test "it doesn't create an all function" do
      refute Keyword.has_key?(People.__info__(:functions), :all)
    end
  end

  describe "change" do
    test "it doesn't create a change function" do
      refute Keyword.has_key?(People.__info__(:functions), :change)
    end
  end

  describe "changeset" do
    test "it doesn't create a changeset function" do
      refute Keyword.has_key?(People.__info__(:functions), :changeset)
    end
  end

  describe "create" do
    test "it doesn't create a create function" do
      refute Keyword.has_key?(People.__info__(:functions), :create)
    end
  end

  describe "create!" do
    test "it doesn't create a create! function" do
      refute Keyword.has_key?(People.__info__(:functions), :create!)
    end
  end

  describe "delete" do
    test "with an existing record, it deletes a given record" do
      {:ok, person} =
        %Person{}
        |> Person.changeset(@person_attributes)
        |> Repo.insert()

      assert Repo.all(Person) == [person]

      People.delete(person)

      assert Repo.all(Person) == []
    end

    test "with a non-existent record, it raises an error" do
      {:ok, person} =
        %Person{}
        |> Person.changeset(@person_attributes)
        |> Repo.insert()

      Repo.delete(person)

      assert_raise Ecto.StaleEntryError, fn ->
        People.delete(person)
      end
    end
  end

  describe "delete!" do
    test "with an existing record it deletes the given record" do
      {:ok, person} =
        %Person{}
        |> Person.changeset(@person_attributes)
        |> Repo.insert()

      assert Repo.all(Person) == [person]

      People.delete!(person)

      assert Repo.all(Person) == []
    end

    test "with a non-existent record, it raises an error" do
      {:ok, person} =
        %Person{}
        |> Person.changeset(@person_attributes)
        |> Repo.insert()

      Repo.delete(person)

      assert_raise Ecto.StaleEntryError, fn ->
        People.delete!(person)
      end
    end
  end

  describe "get" do
    test "it doesn't create a get function" do
      refute Keyword.has_key?(People.__info__(:functions), :get)
    end
  end

  describe "get!" do
    test "it doesn't create a get! function" do
      refute Keyword.has_key?(People.__info__(:functions), :get!)
    end
  end

  describe "get_by" do
    test "it doesn't create a get_by function" do
      refute Keyword.has_key?(People.__info__(:functions), :get_by)
    end
  end

  describe "get_by!" do
    test "it doesn't create a get_by! function" do
      refute Keyword.has_key?(People.__info__(:functions), :get_by!)
    end
  end

  describe "update" do
    test "it doesn't create an update function" do
      refute Keyword.has_key?(People.__info__(:functions), :update)
    end
  end

  describe "update!" do
    test "it doesn't create an update! function" do
      refute Keyword.has_key?(People.__info__(:functions), :update!)
    end
  end
end
