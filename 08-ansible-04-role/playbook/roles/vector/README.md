Vector.yml
=========

Роль для установки Vector 

Role Variables
--------------

| vars | Description | Value | Location |
|------|------------|---|---|
| vector_version | Vector version to install | 0.26.0 | group_vars/vector/vars.yml |
| vector_dir | Vector path | /etc/vector | group_vars/vector/vars.yml |
| vector_template | Vector template script | | templates/vector.sh.j2 |

lighthouse.yml