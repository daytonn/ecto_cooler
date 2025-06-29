defmodule EctoCooler.ReadTestContext.People do
  @moduledoc false

  alias EctoCooler.TestRepo
  alias EctoCooler.TestSchema.Person

  use EctoCooler

  using_repo TestRepo do
    resource(Person, :read)
  end
end

defmodule EctoCooler.ReadTest do
  use EctoCooler.RepoCase

  alias EctoCooler.TestSchema.Person
  alias EctoCooler.ReadTestContext.People

  @person_attributes %{
    first_name: "Test",
    last_name: "Person",
    age: 42
  }

  describe "all" do
    test "it returns all the records" do
      person = struct(Person, @person_attributes)

      Repo.insert(person)
      [first_person] = results = People.all()

      assert length(results) == 1
      assert person.first_name == first_person.first_name
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
    test "it doesn't create a delete function" do
      refute Keyword.has_key?(People.__info__(:functions), :delete)
    end
  end

  describe "delete!" do
    test "it doesn't create a delete! function" do
      refute Keyword.has_key?(People.__info__(:functions), :delete!)
    end
  end

  describe "get" do
    test "with an existing record, it returns the schema" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert person == People.get(person.id)
    end

    test "with a non-existent record, it returns nil" do
      assert nil == People.get(999)
    end
  end

  describe "get!" do
    test "with an existing record, it returns the schema" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert person == People.get!(person.id)
    end

    test "with a non-existent record, it raises an error" do
      assert_raise Ecto.NoResultsError, fn ->
        People.get!(999)
      end
    end
  end

  describe "get_by" do
    test "with an existing record, it returns a single schema matching the criteria" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert People.get_by(age: @person_attributes.age) == person
    end

    test "with a non-existent record, it returns nil" do
      assert People.get_by(age: @person_attributes.age) == nil
    end
  end

  describe "get_by!" do
    test "with an existing record, it returns a single schema, matching the criteria" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert People.get_by!(age: @person_attributes.age) == person
    end
  end

  describe "update" do
    test "it doesn't create an update function" do
      refute Keyword.has_key?(People.__info__(:functions), :update)
    end
  end

  describe "update!" do
    test "it doesn't create an update function" do
      refute Keyword.has_key?(People.__info__(:functions), :update!)
    end
  end
end
