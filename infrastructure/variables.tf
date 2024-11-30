variable key_pair_name {
    description     = "AWS key pair name"
    type            = string
    default         = "michal"
}

variable root_volume_size {
    description     = "EC2 root volume size"
    default         = 8
}