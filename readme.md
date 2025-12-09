[ Git push ]
      ↓
[ Jenkins webhook ]
      ↓
[ Pipeline start ]
      ↓
[ Docker build ]
      ↓
[ Docker push to DockerHub ]
      ↓
[ Terraform apply -> create app server ]
      ↓
[ Ansible deploy on app ]
      ↓
[ Done ]
