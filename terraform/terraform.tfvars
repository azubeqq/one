# terraform.tfvars
region = "eu-central-1"
# Замените на имя вашего ключа и путь к публичному ключу
key_name = "jenkins_ec2_key"
#public_key_path = "~/.ssh/my-aws-key.pub"

# если нужно, можете изменить AMI и размер инстанса

volume_size = 18
instance_type = "t3.small"
project_name = "app-project"
public_subnet_cidr = "10.0.100.0/24"
app_vpc_cidr = "10.0.0.0/16"