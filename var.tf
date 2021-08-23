

  variable "location" {
    default="West Europe"
  }

  variable "resource_group_name" {
    default ="FRG01"
  }
  variable "prefix" {
    default="test"
  }

  variable "address" {
    default=["10.0.0.0/8"]
      
  }

  variable "addresses" {
    default=["10.1.0.0/24"]
  }
  variable "instancevalue" {
    default =2
  }