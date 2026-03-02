defmodule EctoCooler.WriteTestContext.People do
  @moduledoc false

  alias EctoCooler.TestRepo
  alias EctoCooler.TestSchema.Person

  use EctoCooler

  using_repo TestRepo do
    resource(Person, :write)
  end
end

defmodule EctoCooler.WriteTest do
  use EctoCooler.RepoCase

  alias EctoCooler.TestSchema.Person
  alias EctoCooler.WriteTestContext.People

  @person_attributes %{
    first_name: "Test",
    last_name: "Person",
    age: 42
  }

  @updated_person_attributes %{
    first_name: "Updated Test",
    last_name: "Updated Person",
    age: 33
  }

  describe "all" do
    test "it doesn't create an all function" do
      refute Keyword.has_key?(People.__info__(:functions), :all)
    end
  end

  describe "change" do
    test "it returns a changeset with changes" do
      person = %Person{
        first_name: "Initial",
        last_name: "Value",
        age: 0
      }

      %{changes: changes} = People.change(person, @person_attributes)

      assert changes == @person_attributes
    end
  end

  describe "changeset" do
    test "it returns an empty changeset" do
      expected_changeset = Person.changeset(%Person{}, %{})
      assert People.changeset() == expected_changeset
    end
  end

  describe "create" do
    test "with valid attributes, it creates a new record" do
      {:ok, person} = People.create(@person_attributes)

      assert Repo.all(Person) == [person]
    end

    test "with invalid attributes, it returns an error tuple with a changeset" do
      assert {:error, %Ecto.Changeset{}} = People.create(%{})
    end
  end

  describe "create!" do
    test "with valid attributes, it creates a new record" do
      person = People.create!(@person_attributes)

      assert Repo.all(Person) == [person]
    end

    test "with invalid attributes, it raises an error" do
      assert_raise Ecto.InvalidChangesetError, fn ->
        People.create!(%{})
      end
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
    test "with valid attributes, it updates the values" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      {:ok, updated_person} = People.update(person, @updated_person_attributes)

      assert person.id == updated_person.id
      assert person.first_name != updated_person.first_name
      assert person.last_name != updated_person.last_name
      assert person.age != updated_person.age
    end

    test "with invalid attributes, it returns an error changeset tuple" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert {:error, changeset} =
               People.update(person, %{first_name: nil, last_name: nil, age: nil})

      refute changeset.valid?
    end
  end

  describe "update!" do
    test "with valid attributes, it updates the values" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      updated_person = People.update!(person, @updated_person_attributes)

      assert person.id == updated_person.id
      assert person.first_name != updated_person.first_name
      assert person.last_name != updated_person.last_name
      assert person.age != updated_person.age
    end

    test "with invalid attributes, it raises an error" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert_raise Ecto.InvalidChangesetError, fn ->
        People.update!(person, %{first_name: nil, last_name: nil, age: nil})
      end
    end
  end
end
