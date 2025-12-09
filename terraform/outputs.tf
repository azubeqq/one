# outputs.tf - уже есть!
output "instance_public_ip" {
  value = aws_instance.app_server.public_ip
}

output "instance_id" {
  description = "Instance ID"
  value       = aws_instance.app_server.id
}

# Используй null_resource
resource "null_resource" "generate_inventory" {
  depends_on = [aws_instance.app_server]

  provisioner "local-exec" {
    command = <<-EOT
      cat > ${path.module}/../ansible/inventory.ini <<EOF
[aws]
${aws_instance.app_server.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/${var.key_name}.pem
EOF
    EOT
  }

  triggers = {
    instance_ip = aws_instance.app_server.public_ip
  }
}

# SSH команда для подключения
output "ssh_command" {
  description = "Команда для SSH подключения к инстансу"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${aws_instance.app_server.public_ip}"
}
