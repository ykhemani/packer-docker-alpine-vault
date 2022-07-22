#!/bin/bash

packer_command=${packer_command:-validate}
packer_vars=${packer_vars:-yash.pkrvars.hcl}

export HCP_CLIENT_ID=$(vault kv get -field HCP_CLIENT_ID kv/hcp/packer)
export HCP_CLIENT_SECRET=$(vault kv get -field HCP_CLIENT_SECRET kv/hcp/packer)

packer ${packer_command} -var-file=${packer_vars} .
