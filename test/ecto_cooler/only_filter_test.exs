defmodule EctoCooler.OnlyFilterTestContext.People do
  @moduledoc false

  alias EctoCooler.TestRepo
  alias EctoCooler.TestSchema.Person

  use EctoCooler

  using_repo TestRepo do
    resource(Person, only: [:all, :change])
  end
end

defmodule EctoCooler.OnlyFilterTest do
  use EctoCooler.RepoCase

  alias EctoCooler.TestSchema.Person
  alias EctoCooler.OnlyFilterTestContext.People

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
    test "doesn't create a delete function" do
      refute Keyword.has_key?(People.__info__(:functions), :delete)
    end
  end

  describe "delete!" do
    test "doesn't create a delete! function" do
      refute Keyword.has_key?(People.__info__(:functions), :delete!)
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
    test "doesn't create a get_by function" do
      refute Keyword.has_key?(People.__info__(:functions), :get_by)
    end
  end

  describe "get_by!" do
    test "doesn't create a get_by! function" do
      refute Keyword.has_key?(People.__info__(:functions), :get_by!)
    end
  end

  describe "update" do
    test "doesn't create an update function" do
      refute Keyword.has_key?(People.__info__(:functions), :update)
    end
  end

  describe "update!" do
    test "doesn't create an update! function" do
      refute Keyword.has_key?(People.__info__(:functions), :update!)
    end
  end
end
