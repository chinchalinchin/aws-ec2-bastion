// IPS that are whitelisted for access to the EC2
//  NOTE: DO NOT COMMIT YOUR IP ADDRESS TO VERSION CONTROL!
//          Instead, it is recommend you use a TF_VAR_source_ips environment variable!
//          See: https://www.terraform.io/cli/config/environment-variables
//          Sample environment file included in project root under .sample.env

# source_ips = []

// Configuration for EC2 deployment
//  NOTE: Do not commit physical IDs or ARNs to version control!
//      See previous note!
# vpc_config  = {
#     "id": "vpc-xxxx",
#     "subnet_id": "subnet-xxxx",
#     "security_group_ids": ["sg-xxxx", "sg-xxxx"]
# }

bastion_config  = {
    ami                         = "ami-0b0ea68c435eb488d"
    instance_profile            = "AWSRoleforEC2"
    key_name                    = null
    public                      = true
}

project         = "autolib"
