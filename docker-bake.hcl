# docker-bake.hcl

group "build" {
	targets = [
		"8-1-30",
		"8-1-31",
		"8-1-32",
		"8-1-33",
		"8-1-34",
		"8-1-35",
		"8-1-36",
		"8-1-37",
		"8-1-38",
		"8-1-39"
	]
}

variable "BASE_IMAGE_NAME" {
    default = "sales-engineering/ignition"
}

variable "BASE_VERSION" {
    default = "8.1"
}

variable "PATCH_VERSION" {
    default = 39
}

// ###########################################################################################
//  Current Images
// ###########################################################################################

target "8-1-base" {
	context = "."
	args = {
		IGNITION_VERSION = "${BASE_VERSION}.${PATCH_VERSION}"
	}
	platforms = [
		"linux/amd64", 
		"linux/arm64", 
		"linux/arm",
	]
	tags = [
		"${BASE_IMAGE_NAME}:${BASE_VERSION}.${PATCH_VERSION}"
	]
}
// This target inherits the 8-1-base and sets the patch to 30
target "8-1-30" {
	inherits = ["8-1-base"]
	args = {
		IGNITION_VERSION = "8.1.30"
	}
	tags = [
		"${BASE_IMAGE_NAME}:8.1.30"
	]
}

// This target inherits the 8-1-base and sets the patch to 31
target "8-1-31" {
	inherits = ["8-1-base"]
	args = {
		IGNITION_VERSION = "8.1.31"
	}
	tags = [
		"${BASE_IMAGE_NAME}:8.1.31"
	]
}

// This target inherits the 8-1-base and sets the patch to 32
target "8-1-32" {
	inherits = ["8-1-base"]
	args = {
		IGNITION_VERSION = "8.1.32"
	}
	tags = [
		"${BASE_IMAGE_NAME}:8.1.32"
	]
}

// This target inherits the 8-1-base and sets the patch to 33
target "8-1-33" {
	inherits = ["8-1-base"]
	args = {
		IGNITION_VERSION = "8.1.33"
	}
	tags = [
		"${BASE_IMAGE_NAME}:8.1.33"
	]
}

// This target inherits the 8-1-base and sets the patch to 34
target "8-1-34" {
	inherits = ["8-1-base"]
	args = {
		IGNITION_VERSION = "8.1.34"
	}
	tags = [
		"${BASE_IMAGE_NAME}:8.1.34"
	]
}

// This target inherits the 8-1-base and sets the patch to 35
target "8-1-35" {
	inherits = ["8-1-base"]
	args = {
		IGNITION_VERSION = "8.1.35"
	}
	tags = [
		"${BASE_IMAGE_NAME}:8.1.35"
	]
}

// This target inherits the 8-1-base and sets the patch to 36
target "8-1-36" {
	inherits = ["8-1-base"]
	args = {
		IGNITION_VERSION = "8.1.36"
	}
	tags = [
		"${BASE_IMAGE_NAME}:8.1.36"
	]
}

// This target inherits the 8-1-base and sets the patch to 37
target "8-1-37" {
	inherits = ["8-1-base"]
	args = {
		IGNITION_VERSION = "8.1.37"
	}
	tags = [
		"${BASE_IMAGE_NAME}:8.1.37"
	]
}

// This target inherits the 8-1-base and sets the patch to 38
target "8-1-38" {
	inherits = ["8-1-base"]
	args = {
		IGNITION_VERSION = "8.1.38"
	}
	tags = [
		"${BASE_IMAGE_NAME}:8.1.38"
	]
}

// This target inherits the 8-1-base and sets the patch to 39
target "8-1-39" {
	inherits = ["8-1-base"]
	args = {
		IGNITION_VERSION = "8.1.39"
	}
	tags = [
		"${BASE_IMAGE_NAME}:8.1.39"
	]
}
