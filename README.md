# Avalanche subnet

Ansible roles to bootstrap Avalanche nodes and deploy subnets and blockchains.

## Usage

### Environment

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

**Note:** The Docker compose setup is not working.

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
   export ANSIBLE_INVENTORY=ansible/inventory/fuji.hosts
   ```
2. Install + configure avalanchego
   ```sh
   ansible-playbook ansible/bootstrap-fuji-validator.yml
   ```

## TO DO

- [x] Use VMs + SSH rather than Docker containers with local endpoint
- [ ] Check that a subnet with the same validators does not already exist before creation
- [ ] Secure fund private key in vault
- [ ] Always recreate chain aliases on startup
