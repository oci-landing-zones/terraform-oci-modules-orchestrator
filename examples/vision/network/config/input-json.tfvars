fingerprint          = "22:42:ef:92:39:xx:40:2f:yy:ea:9d:59:86:be:xx:b8"
private_key_path     = "path-to-private-key-file.pem"
tenancy_ocid         = "ocid1.tenancy.oc1..aaaaaaa....p2hb"
user_ocid            = "ocid1.user.oc1..aaaaaaaa..vqa"
region               = "us-phoenix-1"
private_key_password = ""

configuration_source        = "file"
local_config_file_paths     = ["../examples/vision/network/config/network-config.json"]
local_dependency_file_paths = ["../examples/vision/iam/config/compartments_output.json"] # dependency file from IAM module to be used as input for networking.
save_output                 = true
output_format               = "json"
output_folder_path          = "../examples/vision/network/config"