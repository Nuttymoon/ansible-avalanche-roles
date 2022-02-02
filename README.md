# Avalanche subnet

Ansible roles to bootstrap Avalanche nodes and deploy subnets and blockchains.

## Usage

- Create/start local Ubuntu VMs
  ```
  vagrant up
  ```
- Install + configure avalanchego
  ```
  ansible-playbook ansible/bootstrap-network.yml -i ansible/inventory
  ```
- Create a subnet with 3 validators
  ```
  ansible-playbook ansible/create-subnet.yml -i ansible/inventory
  ```
- **Manual step:** add the new subnet ID to whitelisted_subnets list in `bootstrap-network.yml`
- Rerun the `bootstrap-network.yml` playbook (to validate the new subnet)
  ```
  ansible-playbook ansible/bootstrap-network.yml -i ansible/inventory
  ```
- Create a timestamp VM blockchain in the new subnet
  ```
  ansible-playbook ansible/create-timestamp-blockchain.yml -i ansible/inventory
  ```
- Create a subnet EVM blockchain in the new subnet
  ```
  ansible-playbook ansible/create-evm-blockchain.yml -i ansible/inventory
  ```

**Note:** The Docker compose setup is not working

## TO DO

- [x] Use VMs + SSH rather than Docker containers with local endpoint
- [ ] Check that a subnet with the same validators does not already exist before creation
- [ ] Secure fund private key in vault
- [ ] Always recreate chain aliases on startup
