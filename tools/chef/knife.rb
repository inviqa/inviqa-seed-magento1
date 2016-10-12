cookbook_path [ "./site-cookbooks" ]
role_path "./roles"
data_bag_path "./data_bags"
environment_path "./environments"
local_mode true

knife[:secret_file] = "./encrypted_data_bag_secret"
