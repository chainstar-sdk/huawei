ACCESS_KEY="WUKINV9DDQCPUCOFTA7I"
SECRET_KEY="6kibtiZafVcEqEBV0SLop0UU4y2TC7xnvyE6EfVb"

# For the provisioning
export TF_VAR_access_key=$ACCESS_KEY
export TF_VAR_secret_key=$SECRET_KEY
# For remote state backend
export AWS_ACCESS_KEY_ID=$ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=$SECRET_KEY


terraform output -json > "outputs.json"