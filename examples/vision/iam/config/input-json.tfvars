fingerprint          = "22:42:ef:92:39:xx:40:2f:yy:ea:9d:59:86:be:xx:b8"
private_key_path     = "path-to-private-key-file.pem"
tenancy_ocid         = "ocid1.tenancy.oc1..aaaaaaa....p2hb"
user_ocid            = "ocid1.user.oc1..aaaaaaaa..vqa"
region               = "us-phoenix-1"
private_key_password = ""

configuration_source    = "file"
local_config_file_paths = ["../examples/vision/iam/config/iam-config.json","../examples/vision/security/config/zpr-config.json"]
save_output             = true
output_format           = "json"
output_folder_path      = "../examples/vision/iam/config"