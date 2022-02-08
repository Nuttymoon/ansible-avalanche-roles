# Ansible Avalanche Roles

Ansible roles to bootstrap [Avalanche](https://docs.avax.network/) validators, create subnets and blockchains.

## Disclaimer

This project is a work in progress. It is provided as is without any guaranty.

## Usage

### Vagrant environment

2 Vagrant environments are available:

- `local`: 5 VMs (RAM = 1 GB, CPU = 2) to bootstrap a local test network
- `fuji`: 1 VM (RAM = 8 GB, CPU = 4) to bootstrap a Fuji (testnet) validator

To switch environment, use symlinks. E.g. to use the `local` setup:

```sh
# Link Vagrantfile to Vagrantfile.local
ln -sf Vagrantfile.local Vagrantfile

# Create/start the VMs
vagrant up
```

**Note:** The `fuji` Vagrant environment is provided as an example. I do not recommand to run a Fuji validator on such a small VM on your PC.

### Custom remote server

To run the playbooks on custom servers (I use this to provision my Fuji validator) create a `hosts` file in `remote/`:

```sh
mkdir -p remote
echo "validator01 ansible_host=$IP_ADDRESS ansible_user=root" > remote/myvalidator.hosts
```

### Provisioning

#### Local test network

1. Set Ansible inventory to `local`
   ```sh
   export ANSIBLE_INVENTORY=ansible/inventory/local.hosts
   ```
2. Install + configure avalanchego
   ```sh
   ansible-playbook ansible/bootstrap-local-network.yml
   ```
3. Create a subnet with 3 validators
   ```sh
   ansible-playbook ansible/create-subnet.yml
   ```
4. **Manual step:** add the new subnet ID to `whitelisted_subnets` list in `bootstrap-local-network.yml`
5. Rerun the `bootstrap-local-network.yml` playbook (to validate the new subnet)
   ```sh
   ansible-playbook ansible/bootstrap-network.yml
   ```
6. Create a blockchain in the new subnet

   1. Compile the VM and add the VM binary in `ansible/files/plugins`
   2. Run the playbook

      ```sh
      # Timestamp VM
      ansible-playbook ansible/create-timestamp-blockchain.yml

      # Subnet EVM
      ansible-playbook ansible/create-evm-blockchain.yml
      ```

#### Fuji validator

1. Set Ansible inventory to `fuji`

   ```sh
   # Local VM
   export ANSIBLE_INVENTORY=ansible/inventory/fuji.hosts

   # Or custom remote hosts
   export ANSIBLE_INVENTORY=remote/myvalidator.hosts
   ```

2. Install + configure avalanchego
   ```sh
   ansible-playbook ansible/bootstrap-fuji-validator.yml
   ```

## TO DO

- [ ] Create an Ansible collection to distribute the roles
- [ ] Check that a subnet with the same validators does not already exist before creation and prompt for confirmation
- [ ] Check that a blockchain using the same VM does not already exist before creation and prompt for confirmation
- [ ] Secure fund private key in vault
- [ ] Always recreate chain aliases on startup
