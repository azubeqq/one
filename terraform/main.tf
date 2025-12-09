data "aws_ami" "latest_amazon_linux_2023" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

#VPC
resource "aws_vpc" "app_vpc" {
  cidr_block = var.app_vpc_cidr  
  
  tags = {
    Name = "${var.project_name}-app-VPC"
    Environment = "${var.environment}"
  }
}

#VPC Subnet
resource "aws_subnet" "app_pub_subnet" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = var.public_subnet_cidr  
  
  map_public_ip_on_launch = true  # Даёт публичный IP

  tags = {
    Name = "${var.project_name}-app-public-subnet"
    Environment = "${var.environment}"
  }
}

#VPC Internet Gsteway
resource "aws_internet_gateway" "app_gw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.project_name}-app-IGW"
    Environment = "${var.environment}"
  }  
}

#VPC Route Table
resource "aws_route_table" "app_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"         # Весь интернет
    gateway_id = aws_internet_gateway.app_gw.id  # → через IGW
  }

    tags = {
      Name = "${var.project_name}-app-RT"
      Environment = "${var.environment}"
  }
}

#VPC Route Table Associations
resource "aws_route_table_association" "j_rta" {
  subnet_id      = aws_subnet.app_pub_subnet.id
  route_table_id = aws_route_table.app_rt.id
}

# Security Group: разрешим SSH + нужные сервисные порты
resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow SSH, Flask, Prometheus, Grafana, Loki + Promtail"

  # SSH
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Flask
  ingress {
    description = "Flask application"
    from_port   = var.flask_port
    to_port     = var.flask_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Prometheus
  ingress {
    description = "Prometheus metrics & UI"
    from_port   = var.prometheus_port
    to_port     = var.prometheus_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Grafana
  ingress {
    description = "Grafana dashboards"
    from_port   = var.grafana_port
    to_port     = var.grafana_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Alertmanager
  ingress {
    description = "Alertmanager UI"
    from_port   = var.alertmanager_port
    to_port     = var.alertmanager_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   # Loki
  ingress {
    description = "Loki description"
    from_port   = var.loki_port
    to_port     = var.loki_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Разрешаем весь исходящий трафик
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-SG"
    Environment = "${var.environment}"
  }
}

resource "aws_key_pair" "jenkins" {
  key_name   = "jenkins_ec2_key"
  public_key = file("/var/lib/jenkins/terraform_keys/jenkins_ec2_key.pub")
}

# EC2 instance
resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.latest_amazon_linux_2023.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

# Увеличиваем размер диска, т.к. будут Docker образы
  root_block_device {
    volume_size = var.volume_size  # GB (дефолт 8GB может быть мало)
    volume_type = var.volume_type  # Современный тип диска
  }

  tags = {
    Name = "${var.project_name}-instance-server"
    Environment = "${var.environment}"
    Role = "app"
    Ansible     = "managed_by_jenkins_server"
  }

  # После создания запишем публичный IP в файл inventory для Ansible
  provisioner "local-exec" {
    command = "echo '[aws]' > ../ansible/inventory.ini && echo '${self.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/${var.key_name}.pem' >> ../ansible/inventory.ini"
  }
}