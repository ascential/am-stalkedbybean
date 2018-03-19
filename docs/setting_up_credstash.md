# Setting up CredStash

You need to go to [the aws console of IAM, section encryption key](https://console.aws.amazon.com/iam/home#/encryptionKeys/eu-west-1) and create a key here. The alias you use will be used everytime you put a value to your secrets.
We advise to use `app_name` as the alias of the key

You can create the table by using
```bash
$ credstash -r your_region -p your_profile -t app_name-environment_name setup
```

You can now add secrets under a key by calling
```bash
$ credstash -r your_region -p your_profile -t app_name-environment_name put -k alias/key_alias key value
```

and consulting a key by doing
```bash
$ credstash -r your_region -p your_profile -t app_name-environment_name get key
```
