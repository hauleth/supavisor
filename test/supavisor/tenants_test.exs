defmodule Supavisor.TenantsTest do
  use Supavisor.DataCase

  alias Supavisor.Tenants

  describe "tenants" do
    alias Supavisor.Tenants.{Tenant, User}

    import Supavisor.TenantsFixtures

    @invalid_attrs %{
      db_database: nil,
      db_host: nil,
      external_id: nil,
      default_parameter_status: nil
    }

    test "get_tenant!/1 returns the tenant with given id" do
      tenant = tenant_fixture()
      assert Tenants.get_tenant!(tenant.id) |> Repo.preload(:users) == tenant
    end

    test "create_tenant/1 with valid data creates a tenant" do
      user_valid_attrs = %{
        "db_user" => "some db_user",
        "db_password" => "some db_password",
        "pool_size" => 3,
        "require_user" => true,
        "mode_type" => "transaction"
      }

      valid_attrs = %{
        db_host: "some db_host",
        db_port: 42,
        db_database: "some db_database",
        external_id: "dev_tenant",
        default_parameter_status: %{"server_version" => "15.0"},
        require_user: true,
        users: [user_valid_attrs]
      }

      assert {:ok, %Tenant{users: [%User{} = user]} = tenant} = Tenants.create_tenant(valid_attrs)
      assert tenant.db_database == "some db_database"
      assert tenant.db_host == "some db_host"
      assert tenant.db_port == 42
      assert tenant.external_id == "dev_tenant"
      assert user.db_password == "some db_password"
      assert user.db_user == "some db_user"
      assert user.pool_size == 3
    end

    test "create_tenant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tenants.create_tenant(@invalid_attrs)
    end

    test "update_tenant/2 with invalid data returns error changeset" do
      tenant = tenant_fixture()
      assert {:error, %Ecto.Changeset{}} = Tenants.update_tenant(tenant, @invalid_attrs)
      assert tenant == Tenants.get_tenant!(tenant.id) |> Repo.preload(:users)
    end

    test "delete_tenant/1 deletes the tenant" do
      tenant = tenant_fixture()
      assert {:ok, %Tenant{}} = Tenants.delete_tenant(tenant)
      assert_raise Ecto.NoResultsError, fn -> Tenants.get_tenant!(tenant.id) end
    end

    test "change_tenant/1 returns a tenant changeset" do
      tenant = tenant_fixture()
      assert %Ecto.Changeset{} = Tenants.change_tenant(tenant)
    end

    test "get_user/3" do
      _tenant = tenant_fixture()
      assert {:error, :not_found} = Tenants.get_user("no_user", "no_tenant", "")
      assert {:ok, %{tenant: _, user: _}} = Tenants.get_user("postgres", "dev_tenant", "")
    end
  end

  describe "clusters" do
    alias Supavisor.Tenants.Cluster

    import Supavisor.TenantsFixtures

    @invalid_attrs %{tenant_external_id: nil, type: nil}

    test "list_clusters/0 returns all clusters" do
      cluster = cluster_fixture()
      assert Tenants.list_clusters() == [cluster]
    end

    test "get_cluster!/1 returns the cluster with given id" do
      cluster = cluster_fixture()
      assert Tenants.get_cluster!(cluster.id) == cluster
    end

    test "create_cluster/1 with valid data creates a cluster" do
      valid_attrs = %{tenant_external_id: "some tenant_external_id", type: "some type"}

      assert {:ok, %Cluster{} = cluster} = Tenants.create_cluster(valid_attrs)
      assert cluster.tenant_external_id == "some tenant_external_id"
      assert cluster.type == "some type"
    end

    test "create_cluster/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tenants.create_cluster(@invalid_attrs)
    end

    test "update_cluster/2 with valid data updates the cluster" do
      cluster = cluster_fixture()

      update_attrs = %{
        tenant_external_id: "some updated tenant_external_id",
        type: "some updated type"
      }

      assert {:ok, %Cluster{} = cluster} = Tenants.update_cluster(cluster, update_attrs)
      assert cluster.tenant_external_id == "some updated tenant_external_id"
      assert cluster.type == "some updated type"
    end

    test "update_cluster/2 with invalid data returns error changeset" do
      cluster = cluster_fixture()
      assert {:error, %Ecto.Changeset{}} = Tenants.update_cluster(cluster, @invalid_attrs)
      assert cluster == Tenants.get_cluster!(cluster.id)
    end

    test "delete_cluster/1 deletes the cluster" do
      cluster = cluster_fixture()
      assert {:ok, %Cluster{}} = Tenants.delete_cluster(cluster)
      assert_raise Ecto.NoResultsError, fn -> Tenants.get_cluster!(cluster.id) end
    end

    test "change_cluster/1 returns a cluster changeset" do
      cluster = cluster_fixture()
      assert %Ecto.Changeset{} = Tenants.change_cluster(cluster)
    end
  end

  describe "clusters" do
    alias Supavisor.Tenants.Cluster

    import Supavisor.TenantsFixtures

    @invalid_attrs %{active: nil}

    test "list_clusters/0 returns all clusters" do
      cluster = cluster_fixture()
      assert Tenants.list_clusters() == [cluster]
    end

    test "get_cluster!/1 returns the cluster with given id" do
      cluster = cluster_fixture()
      assert Tenants.get_cluster!(cluster.id) == cluster
    end

    test "create_cluster/1 with valid data creates a cluster" do
      valid_attrs = %{active: true}

      assert {:ok, %Cluster{} = cluster} = Tenants.create_cluster(valid_attrs)
      assert cluster.active == true
    end

    test "create_cluster/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tenants.create_cluster(@invalid_attrs)
    end

    test "update_cluster/2 with valid data updates the cluster" do
      cluster = cluster_fixture()
      update_attrs = %{active: false}

      assert {:ok, %Cluster{} = cluster} = Tenants.update_cluster(cluster, update_attrs)
      assert cluster.active == false
    end

    test "update_cluster/2 with invalid data returns error changeset" do
      cluster = cluster_fixture()
      assert {:error, %Ecto.Changeset{}} = Tenants.update_cluster(cluster, @invalid_attrs)
      assert cluster == Tenants.get_cluster!(cluster.id)
    end

    test "delete_cluster/1 deletes the cluster" do
      cluster = cluster_fixture()
      assert {:ok, %Cluster{}} = Tenants.delete_cluster(cluster)
      assert_raise Ecto.NoResultsError, fn -> Tenants.get_cluster!(cluster.id) end
    end

    test "change_cluster/1 returns a cluster changeset" do
      cluster = cluster_fixture()
      assert %Ecto.Changeset{} = Tenants.change_cluster(cluster)
    end
  end
end
